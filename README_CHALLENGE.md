### Ruby on Rails Challenge 20200810 ###

Ruby Version: 3.0.2
Rails version: 6.1.x
Database: MySql

# clone the project
git clone https://lab.coodesh.com/daniel1990rocha/ruby-on-rails-20200810.git

# enter the cloned directory
cd api_test

# Gems
- Rspec
- Dotenv-rails

# install Ruby on Rails dependencies
bundle install

# create the development and test databases
rails db:create

# create the tables
rails db:migrate

# run the project
rails s

TESTS (RSPEC)
bundle exec rspec spec/requests/products_spec.rb

## API Endpoints
     
    `GET /`: Get Status: 200 e uma Mensagem "Ruby on Rails Challenge 20200810"
    
    `PUT /products/:productId`: Put a new value of product by id

    `GET /products`: Get all products
    
    `GET /products/:productId`: Get a product by Id

    `POST /products`: Post all products of the 'products.json'

    `DELETE /products/:productId`: Delete a product by id


Any .env.* file is being ignored by this project's GIT.
