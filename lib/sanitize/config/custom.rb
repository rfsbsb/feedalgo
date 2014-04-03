class Sanitize
  module Config
    custom = Sanitize::Config::RELAXED
    custom[:elements].push("iframe")
    custom[:attributes]["iframe"] = ["src", "width", "height", "frameborder", "allowfullscreen"]
    custom[:protocols]["iframe"] = {'href' => ['http', 'https', :relative]}
    CUSTOM = custom
  end
end