require 'database_cleaner'

RSpec.configure do |config|

  config.before :suite do
    DatabaseCleaner.clean_with :truncation
  end

  config.prepend_before(:each) do
    if RSpec.current_example.metadata[:js]
      DatabaseCleaner.strategy = :truncation
    else
      DatabaseCleaner.strategy = :transaction
    end
    DatabaseCleaner.start
  end

  config.append_after(:each) do
    DatabaseCleaner.clean
  end
end
