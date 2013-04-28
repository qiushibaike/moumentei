# -*- encoding : utf-8 -*-
package :git, :provides => :scm do
  description 'Git Distributed Version Control'
  version '1.6.1'
  apt 'git-core'
  verify do
    has_executable 'git'
  end
end
