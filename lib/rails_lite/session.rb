require 'json'
require 'webrick'

class Session
  attr_accessor :cookie
  def initialize(req)


    @cookie = WEBrick::Cookie('_rails_lite_app', "")
    req.cookies.each do |cookie|
      if cookie.name == @cookie.name
        @cookie.value = JSON.parse(cookie)
      end
    end
    @cookie ||= {}
  end

  def [](key)
    @cookie[key]
  end

  def []=(key, val)
    @cookie[key] = val
  end

  def store_session(res)

    res.cookies << @cookie.to_json
  end
end
