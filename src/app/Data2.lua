--
-- Author: Your Name
-- Date: 2016-03-10 17:55:40
--
module("Data2", package.seeall)

function getItemData(num1,num2)
	local itemData = ITEM[num1][num2]
	return itemData
end
function getSnailData(num1,num2)
	local snai--
	-- Author: student
	-- Date: 2015-07-27 18:28:50
	--
	lData = SNAIL[num1][num2]
	return snailData 
end
function getChapterBtnData(num)
	local chapterBtnData = CHAPTERBTN[num]
	return chapterBtnData
end

SCENE = {}
SCENE[1] = {lock = 0, money=5000 ,number=15, type=10}
SCENE[2] = {lock = 0, money=5000 ,number=16, type=10}
SCENE[3] = {lock = 0, money=5000 ,number=17, type=10}
SCENE[4] = {lock = 0, money=5000 ,number=18, type=10}
SCENE[5] = {lock = 0, money=5000 ,number=19, type=10}