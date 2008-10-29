class Download < ActiveRecord::Base
  def expand_path
    File.join(Rails.root, 'public', 'downloads', name)
  end

  def to_param
    name
  end
end
