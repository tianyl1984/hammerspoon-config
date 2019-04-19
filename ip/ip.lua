local configuration = require'hs.network.configuration'
local menubar = hs.menubar.new()
local module = {}

function getTableLen(t)
  local leng=0
  for k, v in pairs(t) do
    leng=leng+1
  end
  return leng;
end

function printTable( tab )
	for key,val in pairs(tab) do
		print(string.format("%s---%s",key,val))
	end
end

function findAddress( inf )
	local addTab = hs.network.addresses(inf);
	for key,val in pairs(addTab) do
		if string.find(val, ':') == nil then
			return val
		end
	end
end

function start(storeObject,keys)
	print('------reset ip menubar--------')
	local ipinfos = {}
	local ifs = hs.network.interfaces();
	for key,val in pairs(ifs) do
		--print(string.format('%s-->%s',key,val))
		local ip = findAddress(val)
		--print(string.format('inf:%s ip:%s',val,ip))
		if ip ~= nil then
			if ip ~= '127.0.0.1' then
				local menu = {
					title = string.format('%s - %s', val, ip),
					fn = function()
						hs.pasteboard.setContents(ip)
						hs.alert.show("已复制:"..ip)
					end
				}
				table.insert(ipinfos, menu)
			end
		end
	end
	if getTableLen(ipinfos) == 0 then
		table.insert(ipinfos, {title = '无网络连接',fn = function() start() end})
	end
	--printTable(ipinfos)
	menubar:setTitle('IP')
	menubar:setTooltip('IP地址')
	menubar:setMenu(ipinfos)
end

start()

module.networkWatcher = configuration.open()
							:setCallback(start)
							:monitorKeys('State:/Network/Interface/.*/IPv4',true)
							:start()

