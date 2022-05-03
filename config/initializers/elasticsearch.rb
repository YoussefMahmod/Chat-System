# config = {
#   host: 'localhost', 
#   transport_options: {
#     headers: {
#       'Content-Type' => 'application/json',
#       'Accept' => 'application/json',
#       'User-Agent' => 'elasticsearch-ruby'
#     },
#     ssl: {
#       verify: false
#     }
#   },
#   port: 9200,
#   scheme: 'https',
#   api_key: {"id":"uE_Nd4AB5PJt2XYVyN-W","name":"ror","api_key":"vjpB-HCQQ0yWEp__YHDKmA","encoded":"dUVfTmQ0QUI1UEp0MlhZVnlOLVc6dmpwQi1IQ1FRMHlXRXBfX1lIREttQQ=="},
#   credentials: {
#     username: 'elastic',
#     password: 'sEyd_QNwyKJ=D94SRqzA',
#     token:'eyJ2ZXIiOiI4LjEuMyIsImFkciI6WyIxOTIuMTY4LjEuMTI6OTIwMCJdLCJmZ3IiOiI0OWI3ODJkNTU5YTRkYTU0NjMyZmUzMWJhYTJiZGVlODliNmJiOTE5NGM5MjExOWU2YjdkODI5ZmEyNTA1N2Q5Iiwia2V5IjoibkJ2T2RZQUJvXzVKY0Vrd0ZxTWk6cFRUS05EMEtSZTJqY0JKMW9WTXpZQSJ9'
#   }
# }

# Elasticsearch::Model.client = Elasticsearch::Client.new(config) # default client

Elasticsearch::Model.client = Elasticsearch::Client.new host: ENV['ES_HOST'],  transport_options: { ssl: { verify: false } }
