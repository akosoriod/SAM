require 'digest'
class User < ApplicationRecord

  validates :first_name, :last_name, :username, :password, :date_birth, presence: {message: "Este campo es obligatorio"}
  validates :username, uniqueness: {message: "El usuario ya se encuentra en uso"}

  validates :password, length: { minimum: 8,
    too_short: "Este campo requiere al menos 8 caracteres" }

  validates :username, length: { minimum: 5,
    too_short: "Este campo requiere al menos 5 caracteres" }

  def full_name
    "#{first_name}#{" "}#{last_name}"
  end

  def set_user
    self.username
  end

  def self.find_by_username(username)
    where(username: username).first
  end

end
