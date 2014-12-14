require "cuba"
require "cuba/render"
require "ohm"

require_relative "models/topic"

Cuba.plugin(Cuba::Render)
Cuba.use Rack::Session::Cookie, secret: "foobar"

Ohm.redis = Redic.new("redis://127.0.0.1:6379")

Cuba.define do
  @page = {}

  on get, "topics/:id" do |id|
    res.write(view("topic",topic:Topic[id]))
  end
  
  on get, "preguntar" do
    res.write(view("new_topic"))
  end
  
  on post, "preguntar" do  
    Topic.create(
      title: req.POST["title"],
      body: req.POST["body"]
    )
    res.write("OK")
  end
  
  on root do
    res.write (view("home", topics: Topic.all))
  end
end