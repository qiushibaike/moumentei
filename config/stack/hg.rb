# -*- encoding : utf-8 -*-
package :hg do
  description 'Mercurial Distributed Version Control'
  apt 'mercurial'
  
  verify do
    has_executable 'hg'
  end
end
