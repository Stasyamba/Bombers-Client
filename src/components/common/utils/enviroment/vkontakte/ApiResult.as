package components.common.utils.enviroment.vkontakte {

import api.vkontakte.util.json.JSON;
import components.common.profiles.VkontakteProfile;
import mx.controls.Alert;

public class ApiResult {
	
    public var settingsResponde:Number;
    public var friends:Array;
    public var appFriends:Array;
	
    public function ApiResult(apiResult:String, immitation:Boolean = false) 
	{
     	encode(apiResult, immitation);
    }

    public function encode(apiResult:String, immitation:Boolean = false):void 
	{
	 	var obj:Object;
    	friends = new Array();
		//mx.controls.Alert.show(apiResult);
		//mx.controls.Alert.show("INHERE!");
		 if (!immitation) 
		 {
		     //obj = JSON.decode(apiResult)['response'];
			 obj = api.vkontakte.util.json.JSON.decode(apiResult)['response'];
		     settingsResponde = obj["settings"];
		
		     var fr:* = obj["friends"];
		
		     if (fr is Array) 
			 {
			     var friendsArr:Array = obj["friends"];
				 
			     for each(var f:Object in friendsArr) 
				 {
				     var up:VkontakteProfile = new VkontakteProfile(f["uid"]);
				
				     up.name = f["first_name"];
				     up.sex = f["sex"];
				     up.surname = f["last_name"];
				     up.photoURL = f["photo"]
				     //up.photoMediumSrc = f["photo_medium"];
				     //up.photoBigSrc = f["photo_big"];
				     up.isFriend = true;
				
				 	 friends.push(up);
			 	 }
	
	 		 }

			 var own:Array = obj["ownProfile"];
			 
			 for each(var p:Object in own) 
			 {
				 Context.Model.currentSettings.socialProfile = new VkontakteProfile(p["uid"]);
				 
				 Context.Model.currentSettings.socialProfile.name = p["first_name"];
				 Context.Model.currentSettings.socialProfile.surname = p["last_name"];
				 Context.Model.currentSettings.socialProfile.photoURL = p["photo_medium"]
				
			 }
			 
			 
		     //Context.Model.currentSettings.socialProfile = new VkontakteProfile(obj["ownProfile"]["uid"]); 
			 //Context.Model.currentSettings.socialProfile.name = (obj["ownProfile"]["first_name"] as String).split(" ")[0] as String;
			 //Context.Model.currentSettings.socialProfile.photoURL = obj["ownProfile"]["photo"];
			 
		     //Context.Model.currentSettings.ownVkProfile.photoSrc = obj["ownProfile"]["user_photo"];

	     } else {
			 
		     var apiR:String = "{\"response\":{\"settings\":3," +
		     "\"app_friends\":{}," +
		     "\"ownProfile\":{\"user_id\":\"72969483\",\"user_name\":\"Egor Bublz\",\"user_sex\":\"2\",\"user_bdate\":\"7.9.1988\",\"user_city\":\"Caribbean islands\",\"user_photo\":\"http:\/\/cs9365.vkontakte.ru\/u72969483\/a_c45b7d9d.jpg\"}," +
		     "\"friends\":[{\"uid\":19180,\"first_name\":\"Сергей\",\"last_name\":\"Туленцев\",\"sex\":\"2\",\"photo\":\"http:\/\/cs10393.vkontakte.ru\/u19180\/c_484ecf54.jpg\",\"photo_medium\":\"http:\/\/cs10393.vkontakte.ru\/u19180\/b_bdf9c2ca.jpg\",\"photo_big\":\"http:\/\/cs10393.vkontakte.ru\/u19180\/a_201d36ff.jpg\"},{\"uid\":36018,\"first_name\":\"Стас\",\"last_name\":\"Дубров\",\"sex\":\"2\",\"photo\":\"http:\/\/cs4232.vkontakte.ru\/u36018\/c_ea7d6b83.jpg\",\"photo_medium\":\"http:\/\/cs4232.vkontakte.ru\/u36018\/b_f48c7e00.jpg\",\"photo_big\":\"http:\/\/cs4232.vkontakte.ru\/u36018\/a_5c1e52f2.jpg\"},{\"uid\":40428,\"first_name\":\"Борис\",\"last_name\":\"Мунтян\",\"sex\":\"2\",\"photo\":\"http:\/\/cs4553.vkontakte.ru\/u40428\/c_8656d3db.jpg\",\"photo_medium\":\"http:\/\/cs4553.vkontakte.ru\/u40428\/b_61a58b19.jpg\",\"photo_big\":\"http:\/\/cs4553.vkontakte.ru\/u40428\/a_45096054.jpg\"},{\"uid\":56152,\"first_name\":\"Виктория\",\"last_name\":\"Коваленко\",\"sex\":\"1\",\"photo\":\"http:\/\/cs4300.vkontakte.ru\/u56152\/c_c9b6c114.jpg\",\"photo_medium\":\"http:\/\/cs4300.vkontakte.ru\/u56152\/b_f7220b86.jpg\",\"photo_big\":\"http:\/\/cs4300.vkontakte.ru\/u56152\/a_0ed617c5.jpg\"},{\"uid\":71957,\"first_name\":\"Nadusha\",\"last_name\":\"Komarova\",\"sex\":\"1\",\"photo\":\"http:\/\/cs4751.vkontakte.ru\/u71957\/c_3fa572e9.jpg\",\"photo_medium\":\"http:\/\/cs4751.vkontakte.ru\/u71957\/b_a48a79e7.jpg\",\"photo_big\":\"http:\/\/cs4751.vkontakte.ru\/u71957\/a_3ce4934f.jpg\"},{\"uid\":78303,\"first_name\":\"Соня\",\"last_name\":\"Савельева\",\"sex\":\"1\",\"photo\":\"http:\/\/cs5108.vkontakte.ru\/u78303\/c_896aa580.jpg\",\"photo_medium\":\"http:\/\/cs5108.vkontakte.ru\/u78303\/b_81cf8e9a.jpg\",\"photo_big\":\"http:\/\/cs5108.vkontakte.ru\/u78303\/a_3d84b90f.jpg\"},{\"uid\":82368,\"first_name\":\"Макс\",\"last_name\":\"Медведев\",\"sex\":\"2\",\"photo\":\"http:\/\/cs4426.vkontakte.ru\/u82368\/c_68cb6492.jpg\",\"photo_medium\":\"http:\/\/cs4426.vkontakte.ru\/u82368\/b_5d15b66e.jpg\",\"photo_big\":\"http:\/\/cs4426.vkontakte.ru\/u82368\/a_e2e38013.jpg\"},{\"uid\":135181,\"first_name\":\"Елена\",\"last_name\":\"Маргулис\",\"sex\":\"1\",\"photo\":\"http:\/\/cs4173.vkontakte.ru\/u135181\/c_788a74e7.jpg\",\"photo_medium\":\"http:\/\/cs4173.vkontakte.ru\/u135181\/b_243c90ef.jpg\",\"photo_big\":\"http:\/\/cs4173.vkontakte.ru\/u135181\/a_7f154510.jpg\"},{\"uid\":196221,\"first_name\":\"Илья\",\"last_name\":\"Соломка\",\"sex\":\"2\",\"photo\":\"http:\/\/cs9656.vkontakte.ru\/u196221\/c_07d96690.jpg\",\"photo_medium\":\"http:\/\/cs9656.vkontakte.ru\/u196221\/b_30808602.jpg\",\"photo_big\":\"http:\/\/cs9656.vkontakte.ru\/u196221\/a_06b1f6d6.jpg\"},{\"uid\":229852,\"first_name\":\"Элечка\",\"last_name\":\"Glazastik\",\"sex\":\"1\",\"photo\":\"http:\/\/cs4567.vkontakte.ru\/u229852\/c_8a9720b1.jpg\",\"photo_medium\":\"http:\/\/cs4567.vkontakte.ru\/u229852\/b_a78f3520.jpg\",\"photo_big\":\"http:\/\/cs4567.vkontakte.ru\/u229852\/a_9ba88273.jpg\"},{\"uid\":236115,\"first_name\":\"Наталия\",\"last_name\":\"Быкадорова\",\"sex\":\"1\",\"photo\":\"http:\/\/cs9311.vkontakte.ru\/u236115\/c_50beb4d1.jpg\",\"photo_medium\":\"http:\/\/cs9311.vkontakte.ru\/u236115\/b_f6c9f62c.jpg\",\"photo_big\":\"http:\/\/cs9311.vkontakte.ru\/u236115\/a_488cbd9b.jpg\"},{\"uid\":241285,\"first_name\":\"Евгений\",\"last_name\":\"Абрамов\",\"sex\":\"2\",\"photo\":\"http:\/\/cs4230.vkontakte.ru\/u241285\/c_e55e28ea.jpg\",\"photo_medium\":\"http:\/\/cs4230.vkontakte.ru\/u241285\/b_105a70b0.jpg\",\"photo_big\":\"http:\/\/cs4230.vkontakte.ru\/u241285\/a_9846617b.jpg\"},{\"uid\":248567,\"first_name\":\"Дмитрий\",\"last_name\":\"Громыко\",\"sex\":\"2\",\"photo\":\"http:\/\/vkontakte.ru\/images\/question_c.gif\",\"photo_medium\":\"http:\/\/vkontakte.ru\/images\/question_b.gif\",\"photo_big\":\"http:\/\/vkontakte.ru\/images\/question_a.gif\"},{\"uid\":319661,\"first_name\":\"Маргарита\",\"last_name\":\"Курбатова\",\"sex\":\"1\",\"photo\":\"http:\/\/cs4741.vkontakte.ru\/u319661\/c_29695343.jpg\",\"photo_medium\":\"http:\/\/cs4741.vkontakte.ru\/u319661\/b_e07cd1e6.jpg\",\"photo_big\":\"http:\/\/cs4741.vkontakte.ru\/u319661\/a_a0365834.jpg\"},{\"uid\":386602,\"first_name\":\"Елена\",\"last_name\":\"Масолова\",\"sex\":\"1\",\"photo\":\"http:\/\/cs4427.vkontakte.ru\/u386602\/c_3fe02fd7.jpg\",\"photo_medium\":\"http:\/\/cs4427.vkontakte.ru\/u386602\/b_2e1e5c3b.jpg\",\"photo_big\":\"http:\/\/cs4427.vkontakte.ru\/u386602\/a_dfbee271.jpg\"},{\"uid\":521692,\"first_name\":\"Анютка\",\"last_name\":\"Киселевская\",\"sex\":\"1\",\"photo\":\"http:\/\/cs4805.vkontakte.ru\/u521692\/c_ef40b171.jpg\",\"photo_medium\":\"http:\/\/cs4805.vkontakte.ru\/u521692\/b_b57049d6.jpg\",\"photo_big\":\"http:\/\/cs4805.vkontakte.ru\/u521692\/a_0dfffa3a.jpg\"},{\"uid\":531341,\"first_name\":\"Алёна\",\"last_name\":\"Семчук\",\"sex\":\"1\",\"photo\":\"http:\/\/cs9884.vkontakte.ru\/u531341\/c_c4d1e2b0.jpg\",\"photo_medium\":\"http:\/\/cs9884.vkontakte.ru\/u531341\/b_7024f3db.jpg\",\"photo_big\":\"http:\/\/cs9884.vkontakte.ru\/u531341\/a_8a73bc6e.jpg\"},{\"uid\":640510,\"first_name\":\"Михаил\",\"last_name\":\"Дорофеев\",\"sex\":\"2\",\"photo\":\"http:\/\/cs10178.vkontakte.ru\/u640510\/c_fc030436.jpg\",\"photo_medium\":\"http:\/\/cs10178.vkontakte.ru\/u640510\/b_149700a2.jpg\",\"photo_big\":\"http:\/\/cs10178.vkontakte.ru\/u640510\/a_38f16942.jpg\"},{\"uid\":669692,\"first_name\":\"Анна\",\"last_name\":\"Касаткина\",\"sex\":\"1\",\"photo\":\"http:\/\/cs9603.vkontakte.ru\/u669692\/c_e3480b96.jpg\",\"photo_medium\":\"http:\/\/cs9603.vkontakte.ru\/u669692\/b_2c93f498.jpg\",\"photo_big\":\"http:\/\/cs9603.vkontakte.ru\/u669692\/a_43f22497.jpg\"},{\"uid\":726515,\"first_name\":\"Кирилл\",\"last_name\":\"Данилюк\",\"sex\":\"2\",\"photo\":\"http:\/\/vkontakte.ru\/images\/question_c.gif\",\"photo_medium\":\"http:\/\/vkontakte.ru\/images\/question_b.gif\",\"photo_big\":\"http:\/\/vkontakte.ru\/images\/question_a.gif\"},{\"uid\":804677,\"first_name\":\"Василий\",\"last_name\":\"Ветров\",\"sex\":\"2\",\"photo\":\"http:\/\/cs9251.vkontakte.ru\/u804677\/c_54abe157.jpg\",\"photo_medium\":\"http:\/\/cs9251.vkontakte.ru\/u804677\/b_ef5f4835.jpg\",\"photo_big\":\"http:\/\/cs9251.vkontakte.ru\/u804677\/a_7127ab0d.jpg\"},{\"uid\":916939,\"first_name\":\"Олюня\",\"last_name\":\"Тугузова\",\"sex\":\"1\",\"photo\":\"http:\/\/cs4239.vkontakte.ru\/u916939\/c_9bd90f10.jpg\",\"photo_medium\":\"http:\/\/cs4239.vkontakte.ru\/u916939\/b_2ffa9d6a.jpg\",\"photo_big\":\"http:\/\/cs4239.vkontakte.ru\/u916939\/a_121bb044.jpg\"},{\"uid\":1019187,\"first_name\":\"Владимир\",\"last_name\":\"Павкин\",\"sex\":\"2\",\"photo\":\"http:\/\/cs4125.vkontakte.ru\/u1019187\/c_5b74b302.jpg\",\"photo_medium\":\"http:\/\/cs4125.vkontakte.ru\/u1019187\/b_ba2b7ff9.jpg\",\"photo_big\":\"http:\/\/cs4125.vkontakte.ru\/u1019187\/a_6a130986.jpg\"},{\"uid\":1078903,\"first_name\":\"Лена\",\"last_name\":\"Мельян\",\"sex\":\"0\",\"photo\":\"http:\/\/cs9237.vkontakte.ru\/u1078903\/c_f3333d5b.jpg\",\"photo_medium\":\"http:\/\/cs9237.vkontakte.ru\/u1078903\/b_31d43791.jpg\",\"photo_big\":\"http:\/\/cs9237.vkontakte.ru\/u1078903\/a_0aec96fc.jpg\"},{\"uid\":1090604,\"first_name\":\"Денис\",\"last_name\":\"Гнатченко\",\"sex\":\"2\",\"photo\":\"http:\/\/cs9822.vkontakte.ru\/u1090604\/c_c923acc9.jpg\",\"photo_medium\":\"http:\/\/cs9822.vkontakte.ru\/u1090604\/b_cfe95445.jpg\",\"photo_big\":\"http:\/\/cs9822.vkontakte.ru\/u1090604\/a_436037d7.jpg\"},{\"uid\":1128823,\"first_name\":\"Никита\",\"last_name\":\"Любимов\",\"sex\":\"2\",\"photo\":\"http:\/\/cs4296.vkontakte.ru\/u1128823\/c_e252e82b.jpg\",\"photo_medium\":\"http:\/\/cs4296.vkontakte.ru\/u1128823\/b_b1406c81.jpg\",\"photo_big\":\"http:\/\/cs4296.vkontakte.ru\/u1128823\/a_fae69eb1.jpg\"},{\"uid\":1221733,\"first_name\":\"Алексей\",\"last_name\":\"Куличевский\",\"sex\":\"2\",\"photo\":\"http:\/\/cs10111.vkontakte.ru\/u1221733\/c_7e78cc07.jpg\",\"photo_medium\":\"http:\/\/cs10111.vkontakte.ru\/u1221733\/b_43eeea02.jpg\",\"photo_big\":\"http:\/\/cs10111.vkontakte.ru\/u1221733\/a_b619dea4.jpg\"},{\"uid\":1769588,\"first_name\":\"Наташа\",\"last_name\":\"Федькина\",\"sex\":\"1\",\"photo\":\"http:\/\/cs10011.vkontakte.ru\/u1769588\/c_d018db33.jpg\",\"photo_medium\":\"http:\/\/cs10011.vkontakte.ru\/u1769588\/b_a8ad508c.jpg\",\"photo_big\":\"http:\/\/cs10011.vkontakte.ru\/u1769588\/a_37193e1a.jpg\"},{\"uid\":1782653,\"first_name\":\"Ярина\",\"last_name\":\"Капко\",\"sex\":\"1\",\"photo\":\"http:\/\/cs9763.vkontakte.ru\/u1782653\/c_408eb384.jpg\",\"photo_medium\":\"http:\/\/cs9763.vkontakte.ru\/u1782653\/b_760b5ec3.jpg\",\"photo_big\":\"http:\/\/cs9763.vkontakte.ru\/u1782653\/a_e2266f2b.jpg\"},{\"uid\":2123481,\"first_name\":\"Константин\",\"last_name\":\"Бондарцов\",\"sex\":\"2\",\"photo\":\"http:\/\/cs4425.vkontakte.ru\/u2123481\/c_118b2917.jpg\",\"photo_medium\":\"http:\/\/cs4425.vkontakte.ru\/u2123481\/b_673c4841.jpg\",\"photo_big\":\"http:\/\/cs4425.vkontakte.ru\/u2123481\/a_720474da.jpg\"},{\"uid\":3213925,\"first_name\":\"Яна\",\"last_name\":\"Гареева\",\"sex\":\"0\",\"photo\":\"http:\/\/cs415.vkontakte.ru\/u3213925\/c_b0df9d97.jpg\",\"photo_medium\":\"http:\/\/cs415.vkontakte.ru\/u3213925\/b_97407639.jpg\",\"photo_big\":\"http:\/\/cs415.vkontakte.ru\/u3213925\/a_2a1c63dd.jpg\"},{\"uid\":3228617,\"first_name\":\"Анастасия\",\"last_name\":\"Погодина\",\"sex\":\"1\",\"photo\":\"http:\/\/cs10310.vkontakte.ru\/u3228617\/c_ccc2cd8c.jpg\",\"photo_medium\":\"http:\/\/cs10310.vkontakte.ru\/u3228617\/b_e191cb0a.jpg\",\"photo_big\":\"http:\/\/cs10310.vkontakte.ru\/u3228617\/a_1d579ac3.jpg\"},{\"uid\":3325611,\"first_name\":\"Ефанов\",\"last_name\":\"Филипп\",\"sex\":\"2\",\"photo\":\"http:\/\/cs4736.vkontakte.ru\/u3325611\/c_a28e23ca.jpg\",\"photo_medium\":\"http:\/\/cs4736.vkontakte.ru\/u3325611\/b_bd46ae0c.jpg\",\"photo_big\":\"http:\/\/cs4736.vkontakte.ru\/u3325611\/a_ac9f4bbd.jpg\"},{\"uid\":3496914,\"first_name\":\"Елена\",\"last_name\":\"Степченко\",\"sex\":\"1\",\"photo\":\"http:\/\/cs726.vkontakte.ru\/u3496914\/c_3c35c6dc.jpg\",\"photo_medium\":\"http:\/\/cs726.vkontakte.ru\/u3496914\/b_fd2b9603.jpg\",\"photo_big\":\"http:\/\/cs726.vkontakte.ru\/u3496914\/a_6215080d.jpg\"},{\"uid\":5393144,\"first_name\":\"Инна\",\"last_name\":\"Манаенкова\",\"sex\":\"1\",\"photo\":\"http:\/\/cs4537.vkontakte.ru\/u5393144\/c_7a3bda54.jpg\",\"photo_medium\":\"http:\/\/cs4537.vkontakte.ru\/u5393144\/b_fa8264bf.jpg\",\"photo_big\":\"http:\/\/cs4537.vkontakte.ru\/u5393144\/a_99e8ce1f.jpg\"},{\"uid\":7265902,\"first_name\":\"Максим\",\"last_name\":\"Шевчук\",\"sex\":\"2\",\"photo\":\"http:\/\/cs9689.vkontakte.ru\/u7265902\/c_effb08fe.jpg\",\"photo_medium\":\"http:\/\/cs9689.vkontakte.ru\/u7265902\/b_a5c25a48.jpg\",\"photo_big\":\"http:\/\/cs9689.vkontakte.ru\/u7265902\/a_bcc36206.jpg\"},{\"uid\":12701649,\"first_name\":\"Екатерина\",\"last_name\":\"Долина\",\"sex\":\"1\",\"photo\":\"http:\/\/cs9952.vkontakte.ru\/u12701649\/c_43204dff.jpg\",\"photo_medium\":\"http:\/\/cs9952.vkontakte.ru\/u12701649\/b_07259c9b.jpg\",\"photo_big\":\"http:\/\/cs9952.vkontakte.ru\/u12701649\/a_46b7efba.jpg\"},{\"uid\":14195642,\"first_name\":\"Kravtsova\",\"last_name\":\"Irka\",\"sex\":\"1\",\"photo\":\"http:\/\/cs9778.vkontakte.ru\/u14195642\/c_a0145968.jpg\",\"photo_medium\":\"http:\/\/cs9778.vkontakte.ru\/u14195642\/b_b5b8cbfa.jpg\",\"photo_big\":\"http:\/\/cs9778.vkontakte.ru\/u14195642\/a_d527da80.jpg\"},{\"uid\":14672890,\"first_name\":\"Кристиночка\",\"last_name\":\"Луговая\",\"sex\":\"1\",\"photo\":\"http:\/\/cs1431.vkontakte.ru\/u14672890\/c_69c7b317.jpg\",\"photo_medium\":\"http:\/\/cs1431.vkontakte.ru\/u14672890\/b_a0fb7f54.jpg\",\"photo_big\":\"http:\/\/cs1431.vkontakte.ru\/u14672890\/a_7705ccf5.jpg\"},{\"uid\":22003813,\"first_name\":\"Miss\",\"last_name\":\"Raubitch\",\"sex\":\"1\",\"photo\":\"http:\/\/cs9975.vkontakte.ru\/u22003813\/c_1160d81c.jpg\",\"photo_medium\":\"http:\/\/cs9975.vkontakte.ru\/u22003813\/b_3fec3a09.jpg\",\"photo_big\":\"http:\/\/cs9975.vkontakte.ru\/u22003813\/a_72c271e0.jpg\"},{\"uid\":22441933,\"first_name\":\"Dasha\",\"last_name\":\"Naletova\",\"sex\":\"1\",\"photo\":\"http:\/\/cs603.vkontakte.ru\/u22441933\/c_b2403c75.jpg\",\"photo_medium\":\"http:\/\/cs603.vkontakte.ru\/u22441933\/b_7517bfa2.jpg\",\"photo_big\":\"http:\/\/cs603.vkontakte.ru\/u22441933\/a_2c2e0ae0.jpg\"},{\"uid\":27544271,\"first_name\":\"Max\",\"last_name\":\"Daniloff\",\"sex\":\"2\",\"photo\":\"http:\/\/cs9935.vkontakte.ru\/u27544271\/c_c295f3d8.jpg\",\"photo_medium\":\"http:\/\/cs9935.vkontakte.ru\/u27544271\/b_f3538c5a.jpg\",\"photo_big\":\"http:\/\/cs9935.vkontakte.ru\/u27544271\/a_28f0f10a.jpg\"},{\"uid\":34230304,\"first_name\":\"Олег\",\"last_name\":\"Никулин\",\"sex\":\"2\",\"photo\":\"http:\/\/cs4665.vkontakte.ru\/u34230304\/c_81ab2367.jpg\",\"photo_medium\":\"http:\/\/cs4665.vkontakte.ru\/u34230304\/b_b363c579.jpg\",\"photo_big\":\"http:\/\/cs4665.vkontakte.ru\/u34230304\/a_807697e8.jpg\"},{\"uid\":37365548,\"first_name\":\"Екатерина\",\"last_name\":\"Герцен\",\"sex\":\"1\",\"photo\":\"http:\/\/cs9814.vkontakte.ru\/u37365548\/c_42ab7bc5.jpg\",\"photo_medium\":\"http:\/\/cs9814.vkontakte.ru\/u37365548\/b_3012ca73.jpg\",\"photo_big\":\"http:\/\/cs9814.vkontakte.ru\/u37365548\/a_36773a32.jpg\"},{\"uid\":46971894,\"first_name\":\"Катя\",\"last_name\":\"Решетникова\",\"sex\":\"1\",\"photo\":\"http:\/\/cs5111.vkontakte.ru\/u46971894\/c_754d2afe.jpg\",\"photo_medium\":\"http:\/\/cs5111.vkontakte.ru\/u46971894\/b_3c95628c.jpg\",\"photo_big\":\"http:\/\/cs5111.vkontakte.ru\/u46971894\/a_b9c0b41d.jpg\"},{\"uid\":51310648,\"first_name\":\"Сергей\",\"last_name\":\"Субботин\",\"sex\":\"2\",\"photo\":\"http:\/\/cs10306.vkontakte.ru\/u51310648\/c_20b967c3.jpg\",\"photo_medium\":\"http:\/\/cs10306.vkontakte.ru\/u51310648\/b_9f1b6bac.jpg\",\"photo_big\":\"http:\/\/cs10306.vkontakte.ru\/u51310648\/a_6438e022.jpg\"},{\"uid\":51553088,\"first_name\":\"Дмитрий\",\"last_name\":\"Оверчук\",\"sex\":\"2\",\"photo\":\"http:\/\/cs9346.vkontakte.ru\/u51553088\/c_41598b9b.jpg\",\"photo_medium\":\"http:\/\/cs9346.vkontakte.ru\/u51553088\/b_fa0dda31.jpg\",\"photo_big\":\"http:\/\/cs9346.vkontakte.ru\/u51553088\/a_9b4bde24.jpg\"},{\"uid\":57935381,\"first_name\":\"Олег\",\"last_name\":\"Козырев\",\"sex\":\"2\",\"photo\":\"http:\/\/cs4333.vkontakte.ru\/u57935381\/c_67a74cae.jpg\",\"photo_medium\":\"http:\/\/cs4333.vkontakte.ru\/u57935381\/b_8dba94fe.jpg\",\"photo_big\":\"http:\/\/cs4333.vkontakte.ru\/u57935381\/a_94095a01.jpg\"},{\"uid\":66361086,\"first_name\":\"Аврора\",\"last_name\":\"Bright\",\"sex\":\"1\",\"photo\":\"http:\/\/cs9572.vkontakte.ru\/u66361086\/c_82af5d8b.jpg\",\"photo_medium\":\"http:\/\/cs9572.vkontakte.ru\/u66361086\/b_c939ab2e.jpg\",\"photo_big\":\"http:\/\/cs9572.vkontakte.ru\/u66361086\/a_5e5ba3cc.jpg\"}]}}"
	
	     	 encode(apiR, false);
	     }
     }

}




}