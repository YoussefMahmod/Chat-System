require 'thread'
class Api::V1::MessagesController < ApplicationController

  def initialize
    @lock = Mutex.new
  end

  # GET /api/v1/applications/:application_token/chats/:chat_number/messages
  def index
    @messages = Message.where(
      chat_number_fk: params[:chat_number],
      app_token_fk: params[:application_token]
    )
    render json: @messages, status: :ok
  end

  # POST /api/v1/applications/:application_token/chats/:chat_number/messages
  def create
    @message = Message.new(
      message_number: 0,
      chat_number_fk: params[:chat_number],
      app_token_fk: params[:application_token],
      message_content: params[:content]
    )

    # Check if our cache flushed we need to updated it with the last inserted number and keep it up to date(Atomically)
    @lock.synchronize do
      if !redis_message_exists(params[:application_token], params[:chat_number])
        last_element_number = Message.where(app_token_fk: params[:application_token], chat_number_fk: params[:chat_number]).maximum("message_number").to_i
        set_message_number(params[:application_token], params[:chat_number], last_element_number)
      end
    end
    
    # Set a new number to our message from cache
    new_message_number = gen_message_number(params[:application_token], params[:chat_number])
    @message.message_number = new_message_number

    if @message.valid?
      # Throw our message creation into the queue
      Publisher.publish('messages', @message.attributes)

      render :json => {
        :app_token => @message.app_token_fk,
        :chat_number => @message.chat_number_fk,
        :message_number => @message.message_number,
        :message_content => @message.message_content,
        :created_at => DateTime.now.to_s,
        :updated_at => DateTime.now.to_s
      }, :status => :created
    else
      render json: @message.errors, status: :unprocessable_entity
    end
  end
    

  # GET /api/v1/applications/:application_token/chats/:chat_number/messages/:id
  def show
    @message = Message.find_by!(
      {
        message_number: params[:id],
        chat_number_fk: params[:chat_number],
        app_token_fk: params[:application_token]
      }
    )
    if !@message.present?
      render json: { error: "Message not found" }, status: :not_found
    else
      render json: @message, status: :ok
    end

  end


  # PATCH /api/v1/applications/:application_token/chats/:chat_number/messages/:id
  def update
    @message = Message.find_by!(
      {
        message_number: params[:id],
        chat_number_fk: params[:chat_number],
        app_token_fk: params[:application_token]
      }
    )
    
    if @message.update(message_content: params[:content])
      render json: @message, status: :ok
    else
      render json: @message.errors, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/applications/:application_token/chats/:chat_number/messages/:id
  def destroy
    @message = Message.find_by!(
      {
        message_number: params[:id],
        chat_number_fk: params[:chat_number],
        app_token_fk: params[:application_token]
      }
    )
    if @message.destroy
      render json: { message: "Message deleted" }, status: :ok
    else
      render json: { error: "Message not found" }, status: :not_found
    end
  end

  # GET /api/v1/applications/:application_token/chats/:chat_number/messages/search
  def search
    identifiers = { 
      app_token: params[:application_token],
      chat_number: params[:chat_number]
     }
    @messages = Message.search(params[:q], identifiers).map do |message|
      {
        :app_token => message.app_token_fk,
        :chat_number => message.chat_number_fk,
        :message_number => message.message_number,
        :message_content => message.message_content,
        :created_at => message.created_at.to_s,
        :updated_at => message.updated_at.to_s
      }
    end

    if @messages.present?
      render json: @messages, status: :ok
    else
      render json: { error: "Message not found" }, status: :not_found
    end
  end



  def message_params
    params.require(:message).permit(:content, :application_token, :chat_number, :id)
  end

  def redis_message_exists(application_token, chat_number)
    REDIS.exists?("#{application_token}_#{chat_number}_message_number")
  end

  def set_message_number(app_token, chat_number, message_number)
    REDIS.set("#{app_token}_#{chat_number}_message_number", message_number)
  end

  def gen_message_number(application_token, chat_number)
    REDIS.incr("#{application_token}_#{chat_number}_message_number")
  end

end
