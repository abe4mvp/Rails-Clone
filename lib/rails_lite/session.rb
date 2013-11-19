require 'json'
require 'webrick'

class Session
  attr_accessor :cookie
  def initialize(req)
    @cookie = WEBrick::Cookie.new('_rails_lite_app', {})
    req.cookies.each do |cookie|
      if cookie.name == @cookie.name
        @value = JSON.parse(cookie.value)
        #@cookie = WEBrick::Cookie.new('_rails_lite_app', value)
      end
    end
    @value ||= {}
  end

  def [](key)
    @value[key]
  end

  def []=(key, val)
    @value[key] = val
  end

  def store_session(res)
    @cookie = WEBrick::Cookie.new('_rails_lite_app', @value.to_json)
    res.cookies << @cookie
  end
end
