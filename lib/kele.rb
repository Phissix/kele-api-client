require 'httparty'
require 'json'
require './lib/roadmap.rb'

class Kele
  include HTTParty
  include Roadmap
  attr_reader :auth_token

  def initialize(email, password)
    response = self.class.post(base_url("sessions"), body: { email: email, password: password })
    raise 'Email or password was incorrect' if response.code == 404
    @auth_token = response["auth_token"]
  end

  def get_me
    response = self.class.get(base_url("users/me"), headers: { "authorization" => @auth_token })
    JSON.parse(response.body)
  end

  def get_mentor_availability(mentor_id)
    response = self.class.get(base_url("mentors/#{mentor_id}/student_availability"), headers: { "authorization" => @auth_token })
    JSON.parse(response.body)
  end

  private
  def base_url(endpoint)
    "https://www.bloc.io/api/v1/#{endpoint}"
  end
end
