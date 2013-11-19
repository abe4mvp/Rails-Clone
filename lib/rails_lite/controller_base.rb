require 'erb'
require_relative 'params'
require_relative 'session'
require 'active_support/core_ext'

class ControllerBase
  attr_reader :params

  def initialize(req, res, route_params = {})

    @req, @res = req, res
  end

  def session
    @session ||= Session.new(JSON.parse(@req.cookie))
  end

  def already_rendered?
    #???  @already_built_response == @res
  end

  def redirect_to(url)
    @res.status = 302
    @res["location"] = url
    Session.store_session(res)
    @already_built_response = @res

  end

  def render_content(content, type)
    @res.body =  content
    @res.content_type =  type
    Session.store_session(res)
    @already_built_response = @res
  end

  def render(template_name)
    controller_name = self.class.to_s.underscore
    template_path = "views/#{controller_name}/#{template_name}.html.erb"
    template_file = File.read(template_path)
    erb_template = ERB.new(template_file).result(binding)

    render_content(erb_template, "text/html")
  end

  def invoke_action(name)
  end
end
