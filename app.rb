#app.rb
require 'sinatra'
require 'sequel'
require 'dotenv'
require 'json'
Dotenv.load
# db config conection
require './db/database_conection'
# models
require_relative './app/models/models'
# controllers
require './app/controllers/controllers'


  class MyApp < Sinatra::Base
    configure do
      enable :sessions
      set :session_secret, ENV['SESSION_SECRET']
    end
    register InitControllers
    helpers do
      def parse_json_request_body
        body = request.body.read
        @json_params = body.empty? ? {} : JSON.parse(body, symbolize_names: true) rescue {}
      end


      def json_params
        @json_params ||= {}
      end
    end

    before do
      parse_json_request_body
    end
    get '/' do
      'Hola Mundo desde Sinatra!'
    end

    not_found do
      'Página no encontrada'
    end

    error do
      'Error interno del servidor'
    end
  end

  if __FILE__ == $0
    MyApp.run!
  end
