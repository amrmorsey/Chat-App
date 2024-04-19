namespace :elasticsearch do
    desc 'Initialize Elasticsearch indexes'
    task create_indexes: :environment do
      models = [Message]
      models.each do |model|
        model.__elasticsearch__.create_index! force: true
      end
      puts 'Elasticsearch indexes created successfully!'
    end
  end
  