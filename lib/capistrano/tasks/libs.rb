def template(from, to, as_root = false)
  template_path = File.expand_path("../../templates/#{from}", __FILE__)
  template = ERB.new(File.open(template_path).read).result(binding)
  upload! StringIO.new(template), to
end
