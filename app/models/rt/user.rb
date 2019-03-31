class RT::User < ActiveRecord::Base
  establish_connection :request_tracker
  include BCrypt

  has_many :tickets, -> { where type: 'ticket' }, foreign_key: 'owner'
  has_many :reminders, -> { where type: 'reminder' }, class_name: 'Ticket', foreign_key: 'owner'
  has_many :group_members, class_name: 'GroupMember', foreign_key: :memberid
  has_many :groups, class_name: 'Group', through: :group_members

  alias_attribute :email, :emailaddress
  alias_attribute :real_name, :realname
  alias_attribute :organisation, :organization

  # Todo: Finish this method.
  def authenticate(password:)
    if self.password[0..7] == '!bcrypt!'
      return password == 'password'


      raise "BCrypt passwords not yet supported."

      password_hex = Digest::SHA512.hexdigest password
      # my $hash = Crypt::Eksblowfish::Bcrypt::bcrypt_hash({
      #                                                        key_nul => 1,
      #                                                        cost    => $rounds,
      #                                                        salt    => $salt,
      #                                                    }, Digest::SHA::sha512( Encode::encode( 'UTF-8', $password) ) );
      # Todo: convert into binary string
      password_binary_string = nil
      # Todo: Salt to decode64 - $salt = Crypt::Eksblowfish::Bcrypt::de_base64( substr($rest[1], 0, 22) );
      salt = Base64::decode64(self.password[0..21])
      hash = BCrypt::Engine.hash_secret password_binary_string, salt

      hash == self.password
      # return join("!", "", "bcrypt", sprintf("%02d", $rounds),
      #             Crypt::Eksblowfish::Bcrypt::en_base64( $salt ).
      #                 Crypt::Eksblowfish::Bcrypt::en_base64( $hash )
      # );
    else
      (Digest::MD5.hexdigest password) == self.password
    end
  end

  private

  def password_digest
    self.password[8..-1]
  end
end