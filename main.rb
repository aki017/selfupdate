require 'uri'
require 'sinatra/base'

class SelfUpdate < Sinatra::Base
  get "/plist/:scheme/:host/:port/:path" do
    scheme = params[:scheme]
    host = params[:host]
    port = params[:port]
    path = params[:path]
    @url = URI.parse "#{scheme}://#{host}:#{port}/#{path}"
    base = [request.scheme, "://", request.host, ":", request.port, "/"].join

    @title = params[:title] || "SelfUpdateApp(#{File.basename(@url.path)})"
    @subtitle= params[:subtitle] || "Visit: http://selfupdate.github.io"
    @icon = params[:icon] || base+"/57.png"
    @bundle = params[:identifier] || "selfupdate.app"
    @full = params[:full] || base+"/icon.png"
    
    erb :plist
  end

  get "/html" do
    @url = URI.parse params[:url]
    base = [request.scheme, "://", request.host, ":", request.port, "/"].join
    path = ["plist", @url.scheme, @url.host, @url.port, @url.path].join("/")
    @plist = base + path
    "<a href=\"itms-services://?action=download-manifest&url=#{@plist}\">Install App</a>"
    erb :html
  end

  run! if app_file == $0
end
