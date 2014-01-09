require 'uri'

class Params
  def initialize(req, route_params)
    
    @params = {}
    @params.merge!(route_params)
    
    @params.merge!(parse_www_encoded_form(req.body)) if req.body 
    @params.merge!(parse_www_encoded_form(req.query_string)) if req.query_string


  end

  def [](key)
    @params[key] 
  end

  def to_s
    @params.to_json.to_s
  end

  private
  def parse_www_encoded_form(www_encoded_form)
    URI.decode_www_form(www_encoded_form)
  end

  def parse_key(key)
  end
end
