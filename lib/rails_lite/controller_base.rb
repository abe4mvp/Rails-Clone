require 'erb'
require_relative 'params'
require_relative 'session'
require 'active_support/core_ext'

class ControllerBase
  attr_reader :params

  def initialize(req, res, route_params = {})
    @already_built_response = true
    @req, @res = req, res
    @params = Params.new(req, route_params)
  end

  def session
    @session ||= Session.new(@req)
  end

  def already_rendered?
    @already_built_response
  end

  def redirect_to(url)
    @res.status = 302
    @res["location"] = url
    session.store_session(res)
    @already_built_response = true

  end

  def render_content(content, type)
    @res.body =  content
    @res.content_type =  type
    session.store_session(@res)
    @already_built_response = true
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
