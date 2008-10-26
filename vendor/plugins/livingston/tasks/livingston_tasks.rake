directory 'doc/app'

file 'doc/app/models.dot' => [:environment, 'doc/app'] do
  explorer = Livingston::Explorer.new
  explorer.explore FileList['app/models/**/*.rb']
    
  File.open('doc/app/models.dot', 'w') do |file|
    file.write(explorer.diagram.to_dot)
  end
end

# TODO don't hardcode Graphviz; look for dot on the PATH instead
file 'doc/app/models.png' => 'doc/app/models.dot' do
  sh '/Applications/Graphviz.app/Contents/MacOS/dot -Tpng doc/app/models.dot > doc/app/models.png'
end
