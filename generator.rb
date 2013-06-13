require 'erb'
require 'yaml'
require 'pp'
require 'pathname'

dir = Pathname.new(__FILE__).dirname
destination = Pathname.new("../PaintField")

template = File::open(dir + "template.erb").read

metainfo = YAML.load(File::open(dir + "pages.yml").read)

langs = metainfo["languages"]
pages = metainfo["pages"]


def get_lang_links(url, langs, current_lang)

  links = Hash.new

  langs.each do |lang, lang_text|

    if current_lang == lang
      links[url] = lang_text
    else
      links["../#{lang}/#{url}"] = lang_text
    end

  end

  return links

end


def get_index_links(pages, current_lang)

  links = Hash.new

  pages.each do |page|
    links[page["url"]] = page[current_lang]
  end

  return links

end


top_url = "index.html"

langs.each_key do |lang|

  index_links = get_index_links(pages, lang)

  pages.each do |page|

    self_url = page["url"]
    lang_links = get_lang_links(self_url, langs, lang)
    contents = File::open(dir + "source/#{lang}/#{self_url}").read

    pp index_links
    pp lang_links
    pp self_url
    
    File::open(destination + "#{lang}/#{self_url}", "w") do |outfile|
      outfile.write(ERB.new(template).result(binding))
    end

  end

end

=begin

top_url = "index.html"
index_links = { "index.html" => "ホーム", "features.html" => "機能", "downloads.html" => "ダウンロード", "faq.html" => "よくある質問" }
lang_links = { "../en/index.html" => "English", "index.html" => "日本語" }
self_url = "index.html"
contents = ""

puts ERB.new(template).result

=end
