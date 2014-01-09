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
    params = {}
    
    keys = URI.decode_www_form(www_encoded_form)
    
    keys.each do |outter_key, value|  # make sure both inner and outter keys are populated correctly
      current_scope = params # reset to outter scope for each iteration
      
      key_sequence = parse_key(outter_key)
      
      key_sequence.each_with_index do  |inner_key, idx|
        if (idx + 1) == key_sequence.count # last key in scope
          current_scope[inner_key] = value
        else
          current_scope[inner_key] ||= {}
          current_scope = current_scope[inner_key]
        end
      end
    end
      
    params
  end

  def parse_key(key) #split up by brackets
    key.split(/\]\[|\[|\]/)
end
