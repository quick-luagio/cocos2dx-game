local keys = {age=1,name=2,sex=3,what=4}
local list = 
{

}

for i=1,10000 do
	table.insert( list, {i,"hello"..i,i*3,"ddd"..i} )
end



return {keys,list}