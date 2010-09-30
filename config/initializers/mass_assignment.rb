# This is an experiment, suggested by
# http://guides.rubyonrails.org/security.html#countermeasures
ActiveRecord::Base.send(:attr_accessible, nil)
