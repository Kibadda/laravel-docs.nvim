local M = {}

M.generate = function (version)
  local dictionary = {'haha'}
  local repository = 'https://github.com/laravel/docs.git'

  if version == nil then
    os.execute('git clone -q ' .. repository .. ' /tmp/laraveldocs')
  else
    os.execute('git clone -q -b ' .. version .. ' ' .. repository .. ' /tmp/laraveldocs')
  end

  os.execute('ls /tmp/laraveldocs > /tmp/laraveldocs.txt')
  os.execute('rm -rf /tmp/laraveldocs')

  return dictionary
end

return M
