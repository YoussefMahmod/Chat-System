require 'thread'
class Api::V1::ChatsController < ApplicationController

  def initialize
    @lock = Mutex.new
  end

  # GET /api/v1/applications/:application_token/chats
  def index
    @chats = Chat.where(app_token_fk: params[:application_token])
    render json: @chats, status: :ok
  end
  
  # GET /api/v1/applications/:application_token/chats/:number
  def show
    @chat = Chat.find_by!(chat_number: params[:number], app_token_fk: params[:application_token])
    if !@chat.present?
      render json: { error: "Chat not found" }, status: :not_found
    else
      render json: @chat, status: :ok
    end
  end

  # POST /api/v1/applications/:application_token/chats
  def create
    # prepare our chat and init chat_number with 0 as default for now
    @chat = Chat.new(chat_number: 0, app_token_fk: params[:application_token])

    # Check if our cache flushed we need to updated it with the last inserted number and keep it up to date(Atomically)
    @lock.synchronize do
      if !redis_chat_exists(params[:application_token])
        last_element_number = Chat.where(app_token_fk: params[:application_token]).maximum("chat_number").to_i
        set_chat_number(params[:application_token], last_element_number)
      end
    end

    # Set our chat_number with the promising one from cache(our next serialized number)
    @chat.chat_number = gen_chat_number(params[:application_token])

    # check if chat is not valid
    if !@chat.valid?
      render json: @chat.errors, status: :unprocessable_entity
    else
      Publisher.publish('chats', @chat.attributes)
    
      render :json => {
        :app_token => @chat.app_token_fk,
        :chat_number => @chat.chat_number,
        :messages_count => 0,
        :created_at => DateTime.now.to_s,
        :updated_at => DateTime.now.to_s
      }, :status => :created
  
    end
    # Throw our chat creation into the queue
    
  end

 

  # DELETE /api/v1/applications/:application_token/chats/:number
  def destroy
    @chat = Chat.find_by!(chat_number: params[:number], app_token_fk: params[:application_token])
    @chat.destroy
    head :no_content
  end

  def chat_params
    params.require(:chat).permit(:application_token, :number)
  end

  # Check if our key exists in the cache
  def redis_chat_exists(application_token)
    REDIS.exists?("#{application_token}_chat_number")
  end

  # Generate our next chat number from cache
  def gen_chat_number(application_token)
    REDIS.incr("#{application_token}_chat_number")
  end
  
  # Set our chat number manually in the cache
  def set_chat_number(application_token, number)
    REDIS.set("#{application_token}_chat_number", number)
  end

end
