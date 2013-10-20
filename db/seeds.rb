# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
Image.create([{ :flavour_type=>"aws",:name =>'Amazon Linux AMI 2013.09 (64-bit)',:image_id=>"ami-35792c5"},
              { :flavour_type=>"aws",:name =>'Amazon Linux AMI 2013.09 (32-bit)',:image_id=>"ami-51792c38"},
              { :flavour_type=>"aws",:name =>'Red Hat Enterprise Linux 6.4 (64-bit)',:image_id=>"ami-a25415cb"},
              { :flavour_type=>"aws",:name =>'Red Hat Enterprise Linux 6.4 (32-bit)',:image_id=>"ami-7e175617"},
              { :flavour_type=>"aws",:name =>'Ubuntu Server 12.04.3 LTS (64-bit)',:image_id=>"ami-a73264ce"},
              { :flavour_type=>"aws",:name =>'Ubuntu Server 12.04.3 LTS (32-bit)',:image_id=>"ami-a53264cc"},
              { :flavour_type=>"aws",:name =>'Ubuntu Server 13.10 LTS (64-bit)',:image_id=>"ami-ad184ac4"},
              { :flavour_type=>"aws",:name =>'Ubuntu Server 13.10 LTS (32-bit)',:image_id=>"ami-a9184ac0"},
              { :flavour_type=>"aws",:name =>'Amazon Linux AMI 2013.09 (64-bit)',:image_id=>"ami-35792c5"},
              { :flavour_type=>"aws",:name =>'Microsoft Windows Server 2008 Base (64-bit)',:image_id=>"ami-373a735e"},
              { :flavour_type=>"aws",:name =>'Microsoft Windows Server 2008 Base (32-bit)',:image_id=>"ami-1b3d7472"},
             ])
