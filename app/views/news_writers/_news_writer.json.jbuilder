json.extract! news_writer, :id, :username, :password, :firstName, :secondName, :bio, :role, :created_at, :updated_at
json.url news_writer_url(news_writer, format: :json)
