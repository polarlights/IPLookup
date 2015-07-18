module API
  class Root < Grape::API
    format :json
    default_format :json
    content_type :json, "application/json;utf-8"
    formatter :json, Grape::Formatter::Rabl

    mount V1::Root
  end
end
