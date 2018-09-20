require 'rack'
class MyController
  def execute(req, res)
    
    if req.path == '/i/love/app/academy'
      res.write('I love app academy heart emoji')
    else 
      res.write 'Hello world!'
    end
  end
end
  

app = Proc.new do |env|
  req = Rack::Request.new(env)
  res = Rack::Response.new
  MyController.new.execute(req, res)  
  res.finish
end




Rack::Server.start(
  app: app,
  Port: 3000
)
