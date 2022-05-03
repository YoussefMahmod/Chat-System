class Message < ApplicationRecord

  # associations
  belongs_to :chat, :foreign_key => :chat_number_fk, :primary_key => :chat_number, :class_name => "Chat"
  belongs_to :application, :foreign_key => :app_token_fk, :primary_key => :app_token, :class_name => "Application"
  
  # validations
  validates :message_content, presence: true


  # Elasticsearch configurations
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  index_name    'instabug'
  document_type 'message'

  es_index_settings = {
    'analysis': {
      'filter': {
        'trigrams_filter': {
          'type': 'ngram',
          'min_gram': 3,
          'max_gram': 3
        }
      },
      'analyzer': {
        'trigrams': {
          'type': 'custom',
          'tokenizer': 'standard',
          'filter': [
            'lowercase',
            'trigrams_filter'
          ]
        }
      }
    }
  }

  settings es_index_settings do
      mapping do
        indexes :message_content, type: 'text', analyzer: 'trigrams'
        indexes :message_number, type: 'integer'
        indexes :chat_number_fk, type: 'integer'
        indexes :app_token_fk, type: 'text'
        indexes :created_at, type: 'date'
        indexes :updated_at, type: 'date'
      end
  end

  def self.search(query, options = {})
    
    __elasticsearch__.search(
      {
        query: {
          bool: {
            must: [
              {
                match: {
                  message_content: {
                    query: query,
                    analyzer: 'trigrams'
                  } 
                }
                
              },
              {
                match: {
                  app_token_fk: options[:app_token]
                }
              },
              {
                match: {
                  chat_number_fk: options[:chat_number]
                }
              },
            ]
          }
        }
      }
    )
  end

end
