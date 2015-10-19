class Sanitize
  module Config
    custom = Sanitize::Config.merge(Sanitize::Config::RELAXED,
                           :elements   => Sanitize::Config::RELAXED[:elements] + ['iframe'],
                           :attributes => {
                               'iframe' => ["src", "width", "height", "frameborder", "allowfullscreen"],
                           },
                           :protocols => {
                               'iframe' => {'href' => ['http', 'https', :relative]}
                           },
                           :remove_contents => true
    )
    CUSTOM = custom
  end
end