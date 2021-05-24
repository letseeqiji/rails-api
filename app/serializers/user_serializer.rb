class UserSerializer
  include JSONAPI::Serializer
  attributes :email, :role
end
