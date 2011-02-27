package components.common.utils.enviroment.vkontakte {
import api.vkontakte.util.json.JSON;

import components.common.profiles.VkontakteProfile;

import mx.controls.Alert;
import mx.utils.ObjectUtil;

public class ApiResult {

    public var settingsResponde:Number;
    public var friends: Array = new Array();
    public var appFriends: Array = new Array();
	public var votes: int = 0;
	
    public function ApiResult(apiResult:String, immitation:Boolean = false) {
        encode(apiResult, immitation);
    }

    public function encode(apiResult:String, immitation:Boolean = false):void {
        var obj:Object;
        
		friends = new Array();
		appFriends = new Array();
		
        if (!immitation) {
           
            obj = JSON.decode(apiResult)['response'];
            settingsResponde = obj["settings"];

			votes = obj["votes"] as int;
			//mx.controls.Alert.show(ObjectUtil.toString({votes: obj["balance"]}));
			
            var fr:* = obj["friends"];

            if (fr is Array) {
                var friendsArr:Array = obj["friends"];

                for each(var f:Object in friendsArr) {
                    var up:VkontakteProfile = new VkontakteProfile(f["uid"]);

                    up.name = f["first_name"];
                    up.sex = f["sex"];
                    up.surname = f["last_name"];
					up.photoURL = f["photo_medium"];
                    up.photoSmallURL = f["photo"];
					
                    //up.photoBigSrc = f["photo_big"];
                    up.isFriend = true;

                    friends.push(up);
                }

            }
			
			var frApp:* = obj["app_friends"];
			
			if (frApp is Array) {
				var friendsAppArr:Array = obj["app_friends"];
				
				for each(f in friendsAppArr) {
					var upAF:VkontakteProfile = new VkontakteProfile(f["uid"]);
					
					upAF.name = f["first_name"];
					upAF.sex = f["sex"];
					upAF.surname = f["last_name"];
					upAF.photoURL = f["photo_medium"];
					
					//up.photoURL = f["photo"]
					//up.photoBigSrc = f["photo_big"];
					upAF.isFriend = true;
					
					appFriends.push(upAF);
				}
				
			}

			for(var i: int = 0; i<= friends.length - 1; i++)
			{
				
				var hasApp: Boolean = false;
				for each(var up2: VkontakteProfile in appFriends)
				{
					if(friends[i].id == up2.id)	
					{
						(friends[i] as VkontakteProfile).haveApp = true;
						break;
					}
				}	
			}
			
            var own:Array = obj["ownProfile"];

            for each(var p:Object in own) {
                Context.Model.currentSettings.socialProfile = new VkontakteProfile(p["uid"]);

                Context.Model.currentSettings.socialProfile.name = p["first_name"];
                Context.Model.currentSettings.socialProfile.surname = p["last_name"];
                Context.Model.currentSettings.socialProfile.photoURL = p["photo_medium"];
            }


            //Context.Model.currentSettings.socialProfile = new VkontakteProfile(obj["ownProfile"]["uid"]);
            //Context.Model.currentSettings.socialProfile.name = (obj["ownProfile"]["first_name"] as String).split(" ")[0] as String;
            //Context.Model.currentSettings.socialProfile.photoURL = obj["ownProfile"]["photo"];

            //Context.Model.currentSettings.ownVkProfile.photoSrc = obj["ownProfile"]["user_photo"];

        } else {

			
			var apiR:String = "{\"response\":{\"app_friends\":[{\"uid\":19180,\"first_name\":\"Сергей\",\"last_name\":\"Туленцев\",\"sex\":\"2\",\"photo\":\"http:\/\/cs11386.vkontakte.ru\/u19180\/e_87322e3b.jpg\",\"photo_medium\":\"http:\/\/cs11386.vkontakte.ru\/u19180\/b_693ca75d.jpg\",\"photo_big\":\"http:\/\/cs11386.vkontakte.ru\/u19180\/a_0852d8c9.jpg\"},{\"uid\":248567,\"first_name\":\"Дмитрий\",\"last_name\":\"Громыко\",\"sex\":\"2\",\"photo\":\"http:\/\/cs11382.vkontakte.ru\/u248567\/e_594fdd48.jpg\",\"photo_medium\":\"http:\/\/cs11382.vkontakte.ru\/u248567\/b_b0d6eb60.jpg\",\"photo_big\":\"http:\/\/cs11382.vkontakte.ru\/u248567\/a_3b225009.jpg\"},{\"uid\":57935381,\"first_name\":\"Олег\",\"last_name\":\"Козырев\",\"sex\":\"2\",\"photo\":\"http:\/\/cs10916.vkontakte.ru\/u57935381\/e_278f021b.jpg\",\"photo_medium\":\"http:\/\/cs10916.vkontakte.ru\/u57935381\/b_5bc9218e.jpg\",\"photo_big\":\"http:\/\/cs10916.vkontakte.ru\/u57935381\/a_68dd1bea.jpg\"}],\"friends\":[{\"uid\":19180,\"first_name\":\"Сергей\",\"last_name\":\"Туленцев\",\"sex\":\"2\",\"photo\":\"http:\/\/cs11386.vkontakte.ru\/u19180\/e_87322e3b.jpg\",\"photo_medium\":\"http:\/\/cs11386.vkontakte.ru\/u19180\/b_693ca75d.jpg\",\"photo_big\":\"http:\/\/cs11386.vkontakte.ru\/u19180\/a_0852d8c9.jpg\"},{\"uid\":36018,\"first_name\":\"Стас\",\"last_name\":\"Дубров\",\"sex\":\"2\",\"photo\":\"http:\/\/cs11308.vkontakte.ru\/u36018\/e_bcf0c099.jpg\",\"photo_medium\":\"http:\/\/cs11308.vkontakte.ru\/u36018\/b_ee806923.jpg\",\"photo_big\":\"http:\/\/cs11308.vkontakte.ru\/u36018\/a_c895bf24.jpg\"},{\"uid\":40428,\"first_name\":\"Борис\",\"last_name\":\"Мунтян\",\"sex\":\"2\",\"photo\":\"http:\/\/cs9258.vkontakte.ru\/u40428\/e_46e2d6f6.jpg\",\"photo_medium\":\"http:\/\/cs9258.vkontakte.ru\/u40428\/b_5ff4339c.jpg\",\"photo_big\":\"http:\/\/cs9258.vkontakte.ru\/u40428\/a_c4875037.jpg\"},{\"uid\":56152,\"first_name\":\"Виктория\",\"last_name\":\"Коваленко\",\"sex\":\"1\",\"photo\":\"http:\/\/cs4300.vkontakte.ru\/u56152\/e_a8f9469b.jpg\",\"photo_medium\":\"http:\/\/cs4300.vkontakte.ru\/u56152\/b_f7220b86.jpg\",\"photo_big\":\"http:\/\/cs4300.vkontakte.ru\/u56152\/a_0ed617c5.jpg\"},{\"uid\":71957,\"first_name\":\"Nadusha\",\"last_name\":\"Komarova\",\"sex\":\"1\",\"photo\":\"http:\/\/cs4751.vkontakte.ru\/u71957\/e_c5c03b91.jpg\",\"photo_medium\":\"http:\/\/cs4751.vkontakte.ru\/u71957\/b_a48a79e7.jpg\",\"photo_big\":\"http:\/\/cs4751.vkontakte.ru\/u71957\/a_3ce4934f.jpg\"},{\"uid\":78303,\"first_name\":\"Соня\",\"last_name\":\"Савельева\",\"sex\":\"1\",\"photo\":\"http:\/\/cs10591.vkontakte.ru\/u78303\/e_0de49661.jpg\",\"photo_medium\":\"http:\/\/cs10591.vkontakte.ru\/u78303\/b_c1d1e760.jpg\",\"photo_big\":\"http:\/\/cs10591.vkontakte.ru\/u78303\/a_6e14d9eb.jpg\"},{\"uid\":82368,\"first_name\":\"Макс\",\"last_name\":\"Медведев\",\"sex\":\"2\",\"photo\":\"http:\/\/cs4426.vkontakte.ru\/u82368\/e_6b7009df.jpg\",\"photo_medium\":\"http:\/\/cs4426.vkontakte.ru\/u82368\/b_5d15b66e.jpg\",\"photo_big\":\"http:\/\/cs4426.vkontakte.ru\/u82368\/a_e2e38013.jpg\"},{\"uid\":86522,\"first_name\":\"Анна\",\"last_name\":\"Борунова\",\"sex\":\"1\",\"photo\":\"http:\/\/cs9742.vkontakte.ru\/u86522\/e_d7004bb5.jpg\",\"photo_medium\":\"http:\/\/cs9742.vkontakte.ru\/u86522\/b_75b6dd4e.jpg\",\"photo_big\":\"http:\/\/cs9742.vkontakte.ru\/u86522\/a_7046eccf.jpg\"},{\"uid\":135181,\"first_name\":\"Елена\",\"last_name\":\"Маргулис\",\"sex\":\"1\",\"photo\":\"http:\/\/cs10576.vkontakte.ru\/u135181\/e_aa0b8213.jpg\",\"photo_medium\":\"http:\/\/cs10576.vkontakte.ru\/u135181\/b_e5fcc291.jpg\",\"photo_big\":\"http:\/\/cs10576.vkontakte.ru\/u135181\/a_b9f16e4c.jpg\"},{\"uid\":196221,\"first_name\":\"Илья\",\"last_name\":\"Соломка\",\"sex\":\"2\",\"photo\":\"http:\/\/cs10543.vkontakte.ru\/u196221\/e_3f6e561d.jpg\",\"photo_medium\":\"http:\/\/cs10543.vkontakte.ru\/u196221\/b_8f7ecc43.jpg\",\"photo_big\":\"http:\/\/cs10543.vkontakte.ru\/u196221\/a_1bbcebcc.jpg\"},{\"uid\":207216,\"first_name\":\"Alexandr\",\"last_name\":\"Drugov\",\"sex\":\"2\",\"photo\":\"http:\/\/cs958.vkontakte.ru\/u207216\/e_3b546d7b.jpg\",\"photo_medium\":\"http:\/\/cs958.vkontakte.ru\/u207216\/b_7e7e6aa8.jpg\",\"photo_big\":\"http:\/\/cs958.vkontakte.ru\/u207216\/a_96f6e0f2.jpg\"},{\"uid\":229852,\"first_name\":\"Элечка\",\"last_name\":\"Glazastik\",\"sex\":\"1\",\"photo\":\"http:\/\/cs9271.vkontakte.ru\/u229852\/e_29c0d572.jpg\",\"photo_medium\":\"http:\/\/cs9271.vkontakte.ru\/u229852\/b_a06c9798.jpg\",\"photo_big\":\"http:\/\/cs9271.vkontakte.ru\/u229852\/a_e83d7472.jpg\"},{\"uid\":236115,\"first_name\":\"Наталия\",\"last_name\":\"Коннова\",\"sex\":\"1\",\"photo\":\"http:\/\/cs10945.vkontakte.ru\/u236115\/e_b433d456.jpg\",\"photo_medium\":\"http:\/\/cs10945.vkontakte.ru\/u236115\/b_d6c5865d.jpg\",\"photo_big\":\"http:\/\/cs10945.vkontakte.ru\/u236115\/a_0f98254f.jpg\"},{\"uid\":241285,\"first_name\":\"Евгений\",\"last_name\":\"Абрамов\",\"sex\":\"2\",\"photo\":\"http:\/\/cs847.vkontakte.ru\/u241285\/e_26e7cd47.jpg\",\"photo_medium\":\"http:\/\/cs847.vkontakte.ru\/u241285\/b_33d70555.jpg\",\"photo_big\":\"http:\/\/cs847.vkontakte.ru\/u241285\/a_ccefba6d.jpg\"},{\"uid\":248567,\"first_name\":\"Дмитрий\",\"last_name\":\"Громыко\",\"sex\":\"2\",\"photo\":\"http:\/\/cs11382.vkontakte.ru\/u248567\/e_594fdd48.jpg\",\"photo_medium\":\"http:\/\/cs11382.vkontakte.ru\/u248567\/b_b0d6eb60.jpg\",\"photo_big\":\"http:\/\/cs11382.vkontakte.ru\/u248567\/a_3b225009.jpg\"},{\"uid\":319661,\"first_name\":\"Маргарита\",\"last_name\":\"Курбатова\",\"sex\":\"1\",\"photo\":\"http:\/\/cs4741.vkontakte.ru\/u319661\/e_79841472.jpg\",\"photo_medium\":\"http:\/\/cs4741.vkontakte.ru\/u319661\/b_e07cd1e6.jpg\",\"photo_big\":\"http:\/\/cs4741.vkontakte.ru\/u319661\/a_a0365834.jpg\"},{\"uid\":386602,\"first_name\":\"Елена\",\"last_name\":\"Масолова\",\"sex\":\"1\",\"photo\":\"http:\/\/cs4427.vkontakte.ru\/u386602\/e_a28b2f6e.jpg\",\"photo_medium\":\"http:\/\/cs4427.vkontakte.ru\/u386602\/b_2e1e5c3b.jpg\",\"photo_big\":\"http:\/\/cs4427.vkontakte.ru\/u386602\/a_dfbee271.jpg\"},{\"uid\":521692,\"first_name\":\"Анютка\",\"last_name\":\"Киселевская\",\"sex\":\"1\",\"photo\":\"http:\/\/cs5095.vkontakte.ru\/u521692\/e_f4f27a6a.jpg\",\"photo_medium\":\"http:\/\/cs5095.vkontakte.ru\/u521692\/b_5ba7b465.jpg\",\"photo_big\":\"http:\/\/cs5095.vkontakte.ru\/u521692\/a_c514e962.jpg\"},{\"uid\":531341,\"first_name\":\"Алёна\",\"last_name\":\"Семчук\",\"sex\":\"1\",\"photo\":\"http:\/\/cs4394.vkontakte.ru\/u531341\/e_1d0ad202.jpg\",\"photo_medium\":\"http:\/\/cs4394.vkontakte.ru\/u531341\/b_49e32f57.jpg\",\"photo_big\":\"http:\/\/cs4394.vkontakte.ru\/u531341\/a_32c2d6a2.jpg\"},{\"uid\":640510,\"first_name\":\"Михаил\",\"last_name\":\"Дорофеев\",\"sex\":\"2\",\"photo\":\"http:\/\/cs11079.vkontakte.ru\/u640510\/e_cd0a0acd.jpg\",\"photo_medium\":\"http:\/\/cs11079.vkontakte.ru\/u640510\/b_cdb51d0e.jpg\",\"photo_big\":\"http:\/\/cs11079.vkontakte.ru\/u640510\/a_c5eb9e93.jpg\"},{\"uid\":669692,\"first_name\":\"Анна\",\"last_name\":\"Касаткина\",\"sex\":\"1\",\"photo\":\"http:\/\/cs9603.vkontakte.ru\/u669692\/e_5855ed02.jpg\",\"photo_medium\":\"http:\/\/cs9603.vkontakte.ru\/u669692\/b_2c93f498.jpg\",\"photo_big\":\"http:\/\/cs9603.vkontakte.ru\/u669692\/a_43f22497.jpg\"},{\"uid\":726515,\"first_name\":\"Кирилл\",\"last_name\":\"Данилюк\",\"sex\":\"2\",\"photo\":\"http:\/\/cs4358.vkontakte.ru\/u726515\/e_c4270563.jpg\",\"photo_medium\":\"http:\/\/cs4358.vkontakte.ru\/u726515\/b_03598172.jpg\",\"photo_big\":\"http:\/\/cs4358.vkontakte.ru\/u726515\/a_956ec6c1.jpg\"},{\"uid\":804677,\"first_name\":\"Василий\",\"last_name\":\"Ветров\",\"sex\":\"2\",\"photo\":\"http:\/\/cs9216.vkontakte.ru\/u804677\/e_99b8db05.jpg\",\"photo_medium\":\"http:\/\/cs9216.vkontakte.ru\/u804677\/b_00364895.jpg\",\"photo_big\":\"http:\/\/cs9216.vkontakte.ru\/u804677\/a_5885984f.jpg\"},{\"uid\":998577,\"first_name\":\"Катя\",\"last_name\":\"Киндер\",\"sex\":\"1\",\"photo\":\"http:\/\/cs10163.vkontakte.ru\/u998577\/e_b7ee6eec.jpg\",\"photo_medium\":\"http:\/\/cs10163.vkontakte.ru\/u998577\/b_bedb9e58.jpg\",\"photo_big\":\"http:\/\/cs10163.vkontakte.ru\/u998577\/a_5ebfa0d5.jpg\"},{\"uid\":1019187,\"first_name\":\"Владимир\",\"last_name\":\"Павкин\",\"sex\":\"2\",\"photo\":\"http:\/\/cs10170.vkontakte.ru\/u1019187\/e_852dea49.jpg\",\"photo_medium\":\"http:\/\/cs10170.vkontakte.ru\/u1019187\/b_d62fe4be.jpg\",\"photo_big\":\"http:\/\/cs10170.vkontakte.ru\/u1019187\/a_0cb94f90.jpg\"},{\"uid\":1078903,\"first_name\":\"Лена\",\"last_name\":\"Мельян\",\"sex\":\"0\",\"photo\":\"http:\/\/cs11206.vkontakte.ru\/u1078903\/e_53c38a1a.jpg\",\"photo_medium\":\"http:\/\/cs11206.vkontakte.ru\/u1078903\/b_17f40cb6.jpg\",\"photo_big\":\"http:\/\/cs11206.vkontakte.ru\/u1078903\/a_72f69dbf.jpg\"},{\"uid\":1090604,\"first_name\":\"Денис\",\"last_name\":\"Гнатченко\",\"sex\":\"2\",\"photo\":\"http:\/\/cs9366.vkontakte.ru\/u1090604\/e_621130d0.jpg\",\"photo_medium\":\"http:\/\/cs9366.vkontakte.ru\/u1090604\/b_d4e1deba.jpg\",\"photo_big\":\"http:\/\/cs9366.vkontakte.ru\/u1090604\/a_4da66022.jpg\"},{\"uid\":1128823,\"first_name\":\"Никита\",\"last_name\":\"Любимов\",\"sex\":\"2\",\"photo\":\"http:\/\/cs10629.vkontakte.ru\/u1128823\/e_ca9169ec.jpg\",\"photo_medium\":\"http:\/\/cs10629.vkontakte.ru\/u1128823\/b_541c32d2.jpg\",\"photo_big\":\"http:\/\/cs10629.vkontakte.ru\/u1128823\/a_89527d70.jpg\"},{\"uid\":1221733,\"first_name\":\"Алексей\",\"last_name\":\"Куличевский\",\"sex\":\"2\",\"photo\":\"http:\/\/cs10111.vkontakte.ru\/u1221733\/e_ec558fe5.jpg\",\"photo_medium\":\"http:\/\/cs10111.vkontakte.ru\/u1221733\/b_43eeea02.jpg\",\"photo_big\":\"http:\/\/cs10111.vkontakte.ru\/u1221733\/a_b619dea4.jpg\"},{\"uid\":1749425,\"first_name\":\"Антон\",\"last_name\":\"Шапоренко\",\"sex\":\"2\",\"photo\":\"http:\/\/cs9739.vkontakte.ru\/u1749425\/e_15172f64.jpg\",\"photo_medium\":\"http:\/\/cs9739.vkontakte.ru\/u1749425\/b_405a379e.jpg\",\"photo_big\":\"http:\/\/cs9739.vkontakte.ru\/u1749425\/a_9ac1bcd4.jpg\"},{\"uid\":1769588,\"first_name\":\"Наташа\",\"last_name\":\"Федькина\",\"sex\":\"1\",\"photo\":\"http:\/\/cs10576.vkontakte.ru\/u1769588\/e_1283eb85.jpg\",\"photo_medium\":\"http:\/\/cs10576.vkontakte.ru\/u1769588\/b_c14f0d9e.jpg\",\"photo_big\":\"http:\/\/cs10576.vkontakte.ru\/u1769588\/a_e7e91fb6.jpg\"},{\"uid\":2123481,\"first_name\":\"Константин\",\"last_name\":\"Бондарцов\",\"sex\":\"2\",\"photo\":\"http:\/\/cs4558.vkontakte.ru\/u2123481\/e_ec6741a0.jpg\",\"photo_medium\":\"http:\/\/cs4558.vkontakte.ru\/u2123481\/b_a75dfbe3.jpg\",\"photo_big\":\"http:\/\/cs4558.vkontakte.ru\/u2123481\/a_3277218f.jpg\"},{\"uid\":3213925,\"first_name\":\"Яна\",\"last_name\":\"Гареева\",\"sex\":\"1\",\"photo\":\"http:\/\/cs10158.vkontakte.ru\/u3213925\/e_81812f3b.jpg\",\"photo_medium\":\"http:\/\/cs10158.vkontakte.ru\/u3213925\/b_7cea7471.jpg\",\"photo_big\":\"http:\/\/cs10158.vkontakte.ru\/u3213925\/a_7856a7dd.jpg\"},{\"uid\":3228617,\"first_name\":\"Анастасия\",\"last_name\":\"Погодина\",\"sex\":\"1\",\"photo\":\"http:\/\/cs10701.vkontakte.ru\/u3228617\/e_845108c4.jpg\",\"photo_medium\":\"http:\/\/cs10701.vkontakte.ru\/u3228617\/b_cb644625.jpg\",\"photo_big\":\"http:\/\/cs10701.vkontakte.ru\/u3228617\/a_cf520585.jpg\"},{\"uid\":3325611,\"first_name\":\"Ефанов\",\"last_name\":\"Филипп\",\"sex\":\"2\",\"photo\":\"http:\/\/cs4736.vkontakte.ru\/u3325611\/e_6df67f03.jpg\",\"photo_medium\":\"http:\/\/cs4736.vkontakte.ru\/u3325611\/b_bd46ae0c.jpg\",\"photo_big\":\"http:\/\/cs4736.vkontakte.ru\/u3325611\/a_ac9f4bbd.jpg\"},{\"uid\":3496914,\"first_name\":\"Елена\",\"last_name\":\"Степченко\",\"sex\":\"1\",\"photo\":\"http:\/\/cs9971.vkontakte.ru\/u3496914\/e_27b4142f.jpg\",\"photo_medium\":\"http:\/\/cs9971.vkontakte.ru\/u3496914\/b_49df5294.jpg\",\"photo_big\":\"http:\/\/cs9971.vkontakte.ru\/u3496914\/a_c0195895.jpg\"},{\"uid\":5393144,\"first_name\":\"Инна\",\"last_name\":\"Манаенкова\",\"sex\":\"1\",\"photo\":\"http:\/\/cs4968.vkontakte.ru\/u5393144\/e_70b7a0d2.jpg\",\"photo_medium\":\"http:\/\/cs4968.vkontakte.ru\/u5393144\/b_26825597.jpg\",\"photo_big\":\"http:\/\/cs4968.vkontakte.ru\/u5393144\/a_f93dacc0.jpg\"},{\"uid\":7265902,\"first_name\":\"Максим\",\"last_name\":\"Шевчук\",\"sex\":\"2\",\"photo\":\"http:\/\/cs10541.vkontakte.ru\/u7265902\/e_1bb42ece.jpg\",\"photo_medium\":\"http:\/\/cs10541.vkontakte.ru\/u7265902\/b_7f49a80f.jpg\",\"photo_big\":\"http:\/\/cs10541.vkontakte.ru\/u7265902\/a_b78791c5.jpg\"},{\"uid\":12701649,\"first_name\":\"Екатерина\",\"last_name\":\"Долина\",\"sex\":\"1\",\"photo\":\"http:\/\/cs10541.vkontakte.ru\/u12701649\/e_b9021713.jpg\",\"photo_medium\":\"http:\/\/cs10541.vkontakte.ru\/u12701649\/b_9ae2c5d6.jpg\",\"photo_big\":\"http:\/\/cs10541.vkontakte.ru\/u12701649\/a_46f7250a.jpg\"},{\"uid\":13384273,\"first_name\":\"Тамара\",\"last_name\":\"Некрасова\",\"sex\":\"1\",\"photo\":\"http:\/\/cs10576.vkontakte.ru\/u13384273\/e_cfd1d01c.jpg\",\"photo_medium\":\"http:\/\/cs10576.vkontakte.ru\/u13384273\/b_20736800.jpg\",\"photo_big\":\"http:\/\/cs10576.vkontakte.ru\/u13384273\/a_9305dd6d.jpg\"},{\"uid\":14195642,\"first_name\":\"Kravtsova\",\"last_name\":\"Irka\",\"sex\":\"1\",\"photo\":\"http:\/\/cs10410.vkontakte.ru\/u14195642\/e_ae06a39f.jpg\",\"photo_medium\":\"http:\/\/cs10410.vkontakte.ru\/u14195642\/b_e76bb4f4.jpg\",\"photo_big\":\"http:\/\/cs10410.vkontakte.ru\/u14195642\/a_4aba47dc.jpg\"},{\"uid\":17109848,\"first_name\":\"Андрей\",\"last_name\":\"Турпанов\",\"sex\":\"2\",\"photo\":\"http:\/\/cs4474.vkontakte.ru\/u17109848\/e_8d87cc17.jpg\",\"photo_medium\":\"http:\/\/cs4474.vkontakte.ru\/u17109848\/b_7821ed67.jpg\",\"photo_big\":\"http:\/\/cs4474.vkontakte.ru\/u17109848\/a_387c56c1.jpg\"},{\"uid\":27544271,\"first_name\":\"Max\",\"last_name\":\"Daniloff\",\"sex\":\"2\",\"photo\":\"http:\/\/cs4977.vkontakte.ru\/u27544271\/e_e5d89f4f.jpg\",\"photo_medium\":\"http:\/\/cs4977.vkontakte.ru\/u27544271\/b_b1c9b387.jpg\",\"photo_big\":\"http:\/\/cs4977.vkontakte.ru\/u27544271\/a_903af010.jpg\"},{\"uid\":34230304,\"first_name\":\"Олег\",\"last_name\":\"Никулин\",\"sex\":\"2\",\"photo\":\"http:\/\/cs10743.vkontakte.ru\/u34230304\/e_782fc24b.jpg\",\"photo_medium\":\"http:\/\/cs10743.vkontakte.ru\/u34230304\/b_be50584d.jpg\",\"photo_big\":\"http:\/\/cs10743.vkontakte.ru\/u34230304\/a_8c8b9f66.jpg\"},{\"uid\":51310648,\"first_name\":\"Сергей\",\"last_name\":\"Субботин\",\"sex\":\"2\",\"photo\":\"http:\/\/cs10306.vkontakte.ru\/u51310648\/e_e1db359f.jpg\",\"photo_medium\":\"http:\/\/cs10306.vkontakte.ru\/u51310648\/b_9f1b6bac.jpg\",\"photo_big\":\"http:\/\/cs10306.vkontakte.ru\/u51310648\/a_6438e022.jpg\"},{\"uid\":51553088,\"first_name\":\"Дмитрий\",\"last_name\":\"Оверчук\",\"sex\":\"2\",\"photo\":\"http:\/\/vkontakte.ru\/images\/question_c.gif\",\"photo_medium\":\"http:\/\/vkontakte.ru\/images\/question_b.gif\",\"photo_big\":\"http:\/\/vkontakte.ru\/images\/question_a.gif\"},{\"uid\":57935381,\"first_name\":\"Олег\",\"last_name\":\"Козырев\",\"sex\":\"2\",\"photo\":\"http:\/\/cs10916.vkontakte.ru\/u57935381\/e_278f021b.jpg\",\"photo_medium\":\"http:\/\/cs10916.vkontakte.ru\/u57935381\/b_5bc9218e.jpg\",\"photo_big\":\"http:\/\/cs10916.vkontakte.ru\/u57935381\/a_68dd1bea.jpg\"},{\"uid\":66361086,\"first_name\":\"Аврора\",\"last_name\":\"Bright\",\"sex\":\"1\",\"photo\":\"http:\/\/cs4443.vkontakte.ru\/u66361086\/e_8989d589.jpg\",\"photo_medium\":\"http:\/\/cs4443.vkontakte.ru\/u66361086\/b_aff1a2f9.jpg\",\"photo_big\":\"http:\/\/cs4443.vkontakte.ru\/u66361086\/a_1169e669.jpg\"},{\"uid\":102994931,\"first_name\":\"Lela\",\"last_name\":\"Tugushi\",\"sex\":\"1\",\"photo\":\"http:\/\/vkontakte.ru\/images\/question_c.gif\",\"photo_medium\":\"http:\/\/vkontakte.ru\/images\/question_b.gif\",\"photo_big\":\"http:\/\/vkontakte.ru\/images\/question_a.gif\"},{\"uid\":120102480,\"first_name\":\"Анастасия\",\"last_name\":\"Романова\",\"sex\":\"1\",\"photo\":\"http:\/\/cs9813.vkontakte.ru\/u120102480\/e_565a7006.jpg\",\"photo_medium\":\"http:\/\/cs9813.vkontakte.ru\/u120102480\/b_2209752c.jpg\",\"photo_big\":\"http:\/\/cs9813.vkontakte.ru\/u120102480\/a_d26acb05.jpg\"},{\"uid\":121299769,\"first_name\":\"Александр\",\"last_name\":\"Мартиросов\",\"sex\":\"2\",\"photo\":\"http:\/\/cs10113.vkontakte.ru\/u121299769\/e_7e89c5e7.jpg\",\"photo_medium\":\"http:\/\/cs10113.vkontakte.ru\/u121299769\/b_d025cfca.jpg\",\"photo_big\":\"http:\/\/cs10113.vkontakte.ru\/u121299769\/a_542bc3f2.jpg\"}],\"ownProfile\":[{\"uid\":72969483,\"first_name\":\"Egor\",\"last_name\":\"Bublz\",\"sex\":\"2\",\"photo\":\"http:\/\/cs4476.vkontakte.ru\/u72969483\/e_e95c8556.jpg\",\"photo_medium\":\"http:\/\/cs4476.vkontakte.ru\/u72969483\/b_ee409c1f.jpg\",\"photo_big\":\"http:\/\/cs4476.vkontakte.ru\/u72969483\/a_8037612a.jpg\"}]}}";
			
            /*var apiR:String = "{\"response\":{\"settings\":3," +
                    "\"app_friends\":{}," +
                    "\"ownProfile\":{\"user_id\":\"72969483\",\"user_name\":\"Egor Bublz\",\"user_sex\":\"2\",\"user_bdate\":\"7.9.1988\",\"user_city\":\"Caribbean islands\",\"user_photo\":\"http:\/\/cs9365.vkontakte.ru\/u72969483\/a_c45b7d9d.jpg\"}," +
                    "\"friends\":[{\"uid\":19180,\"first_name\":\"Сергей\",\"last_name\":\"Туленцев\",\"sex\":\"2\",\"photo\":\"http:\/\/cs10393.vkontakte.ru\/u19180\/c_484ecf54.jpg\",\"photo_medium\":\"http:\/\/cs10393.vkontakte.ru\/u19180\/b_bdf9c2ca.jpg\",\"photo_big\":\"http:\/\/cs10393.vkontakte.ru\/u19180\/a_201d36ff.jpg\"},{\"uid\":36018,\"first_name\":\"Стас\",\"last_name\":\"Дубров\",\"sex\":\"2\",\"photo\":\"http:\/\/cs4232.vkontakte.ru\/u36018\/c_ea7d6b83.jpg\",\"photo_medium\":\"http:\/\/cs4232.vkontakte.ru\/u36018\/b_f48c7e00.jpg\",\"photo_big\":\"http:\/\/cs4232.vkontakte.ru\/u36018\/a_5c1e52f2.jpg\"},{\"uid\":40428,\"first_name\":\"Борис\",\"last_name\":\"Мунтян\",\"sex\":\"2\",\"photo\":\"http:\/\/cs4553.vkontakte.ru\/u40428\/c_8656d3db.jpg\",\"photo_medium\":\"http:\/\/cs4553.vkontakte.ru\/u40428\/b_61a58b19.jpg\",\"photo_big\":\"http:\/\/cs4553.vkontakte.ru\/u40428\/a_45096054.jpg\"},{\"uid\":56152,\"first_name\":\"Виктория\",\"last_name\":\"Коваленко\",\"sex\":\"1\",\"photo\":\"http:\/\/cs4300.vkontakte.ru\/u56152\/c_c9b6c114.jpg\",\"photo_medium\":\"http:\/\/cs4300.vkontakte.ru\/u56152\/b_f7220b86.jpg\",\"photo_big\":\"http:\/\/cs4300.vkontakte.ru\/u56152\/a_0ed617c5.jpg\"},{\"uid\":71957,\"first_name\":\"Nadusha\",\"last_name\":\"Komarova\",\"sex\":\"1\",\"photo\":\"http:\/\/cs4751.vkontakte.ru\/u71957\/c_3fa572e9.jpg\",\"photo_medium\":\"http:\/\/cs4751.vkontakte.ru\/u71957\/b_a48a79e7.jpg\",\"photo_big\":\"http:\/\/cs4751.vkontakte.ru\/u71957\/a_3ce4934f.jpg\"},{\"uid\":78303,\"first_name\":\"Соня\",\"last_name\":\"Савельева\",\"sex\":\"1\",\"photo\":\"http:\/\/cs5108.vkontakte.ru\/u78303\/c_896aa580.jpg\",\"photo_medium\":\"http:\/\/cs5108.vkontakte.ru\/u78303\/b_81cf8e9a.jpg\",\"photo_big\":\"http:\/\/cs5108.vkontakte.ru\/u78303\/a_3d84b90f.jpg\"},{\"uid\":82368,\"first_name\":\"Макс\",\"last_name\":\"Медведев\",\"sex\":\"2\",\"photo\":\"http:\/\/cs4426.vkontakte.ru\/u82368\/c_68cb6492.jpg\",\"photo_medium\":\"http:\/\/cs4426.vkontakte.ru\/u82368\/b_5d15b66e.jpg\",\"photo_big\":\"http:\/\/cs4426.vkontakte.ru\/u82368\/a_e2e38013.jpg\"},{\"uid\":135181,\"first_name\":\"Елена\",\"last_name\":\"Маргулис\",\"sex\":\"1\",\"photo\":\"http:\/\/cs4173.vkontakte.ru\/u135181\/c_788a74e7.jpg\",\"photo_medium\":\"http:\/\/cs4173.vkontakte.ru\/u135181\/b_243c90ef.jpg\",\"photo_big\":\"http:\/\/cs4173.vkontakte.ru\/u135181\/a_7f154510.jpg\"},{\"uid\":196221,\"first_name\":\"Илья\",\"last_name\":\"Соломка\",\"sex\":\"2\",\"photo\":\"http:\/\/cs9656.vkontakte.ru\/u196221\/c_07d96690.jpg\",\"photo_medium\":\"http:\/\/cs9656.vkontakte.ru\/u196221\/b_30808602.jpg\",\"photo_big\":\"http:\/\/cs9656.vkontakte.ru\/u196221\/a_06b1f6d6.jpg\"},{\"uid\":229852,\"first_name\":\"Элечка\",\"last_name\":\"Glazastik\",\"sex\":\"1\",\"photo\":\"http:\/\/cs4567.vkontakte.ru\/u229852\/c_8a9720b1.jpg\",\"photo_medium\":\"http:\/\/cs4567.vkontakte.ru\/u229852\/b_a78f3520.jpg\",\"photo_big\":\"http:\/\/cs4567.vkontakte.ru\/u229852\/a_9ba88273.jpg\"},{\"uid\":236115,\"first_name\":\"Наталия\",\"last_name\":\"Быкадорова\",\"sex\":\"1\",\"photo\":\"http:\/\/cs9311.vkontakte.ru\/u236115\/c_50beb4d1.jpg\",\"photo_medium\":\"http:\/\/cs9311.vkontakte.ru\/u236115\/b_f6c9f62c.jpg\",\"photo_big\":\"http:\/\/cs9311.vkontakte.ru\/u236115\/a_488cbd9b.jpg\"},{\"uid\":241285,\"first_name\":\"Евгений\",\"last_name\":\"Абрамов\",\"sex\":\"2\",\"photo\":\"http:\/\/cs4230.vkontakte.ru\/u241285\/c_e55e28ea.jpg\",\"photo_medium\":\"http:\/\/cs4230.vkontakte.ru\/u241285\/b_105a70b0.jpg\",\"photo_big\":\"http:\/\/cs4230.vkontakte.ru\/u241285\/a_9846617b.jpg\"},{\"uid\":248567,\"first_name\":\"Дмитрий\",\"last_name\":\"Громыко\",\"sex\":\"2\",\"photo\":\"http:\/\/vkontakte.ru\/images\/question_c.gif\",\"photo_medium\":\"http:\/\/vkontakte.ru\/images\/question_b.gif\",\"photo_big\":\"http:\/\/vkontakte.ru\/images\/question_a.gif\"},{\"uid\":319661,\"first_name\":\"Маргарита\",\"last_name\":\"Курбатова\",\"sex\":\"1\",\"photo\":\"http:\/\/cs4741.vkontakte.ru\/u319661\/c_29695343.jpg\",\"photo_medium\":\"http:\/\/cs4741.vkontakte.ru\/u319661\/b_e07cd1e6.jpg\",\"photo_big\":\"http:\/\/cs4741.vkontakte.ru\/u319661\/a_a0365834.jpg\"},{\"uid\":386602,\"first_name\":\"Елена\",\"last_name\":\"Масолова\",\"sex\":\"1\",\"photo\":\"http:\/\/cs4427.vkontakte.ru\/u386602\/c_3fe02fd7.jpg\",\"photo_medium\":\"http:\/\/cs4427.vkontakte.ru\/u386602\/b_2e1e5c3b.jpg\",\"photo_big\":\"http:\/\/cs4427.vkontakte.ru\/u386602\/a_dfbee271.jpg\"},{\"uid\":521692,\"first_name\":\"Анютка\",\"last_name\":\"Киселевская\",\"sex\":\"1\",\"photo\":\"http:\/\/cs4805.vkontakte.ru\/u521692\/c_ef40b171.jpg\",\"photo_medium\":\"http:\/\/cs4805.vkontakte.ru\/u521692\/b_b57049d6.jpg\",\"photo_big\":\"http:\/\/cs4805.vkontakte.ru\/u521692\/a_0dfffa3a.jpg\"},{\"uid\":531341,\"first_name\":\"Алёна\",\"last_name\":\"Семчук\",\"sex\":\"1\",\"photo\":\"http:\/\/cs9884.vkontakte.ru\/u531341\/c_c4d1e2b0.jpg\",\"photo_medium\":\"http:\/\/cs9884.vkontakte.ru\/u531341\/b_7024f3db.jpg\",\"photo_big\":\"http:\/\/cs9884.vkontakte.ru\/u531341\/a_8a73bc6e.jpg\"},{\"uid\":640510,\"first_name\":\"Михаил\",\"last_name\":\"Дорофеев\",\"sex\":\"2\",\"photo\":\"http:\/\/cs10178.vkontakte.ru\/u640510\/c_fc030436.jpg\",\"photo_medium\":\"http:\/\/cs10178.vkontakte.ru\/u640510\/b_149700a2.jpg\",\"photo_big\":\"http:\/\/cs10178.vkontakte.ru\/u640510\/a_38f16942.jpg\"},{\"uid\":669692,\"first_name\":\"Анна\",\"last_name\":\"Касаткина\",\"sex\":\"1\",\"photo\":\"http:\/\/cs9603.vkontakte.ru\/u669692\/c_e3480b96.jpg\",\"photo_medium\":\"http:\/\/cs9603.vkontakte.ru\/u669692\/b_2c93f498.jpg\",\"photo_big\":\"http:\/\/cs9603.vkontakte.ru\/u669692\/a_43f22497.jpg\"},{\"uid\":726515,\"first_name\":\"Кирилл\",\"last_name\":\"Данилюк\",\"sex\":\"2\",\"photo\":\"http:\/\/vkontakte.ru\/images\/question_c.gif\",\"photo_medium\":\"http:\/\/vkontakte.ru\/images\/question_b.gif\",\"photo_big\":\"http:\/\/vkontakte.ru\/images\/question_a.gif\"},{\"uid\":804677,\"first_name\":\"Василий\",\"last_name\":\"Ветров\",\"sex\":\"2\",\"photo\":\"http:\/\/cs9251.vkontakte.ru\/u804677\/c_54abe157.jpg\",\"photo_medium\":\"http:\/\/cs9251.vkontakte.ru\/u804677\/b_ef5f4835.jpg\",\"photo_big\":\"http:\/\/cs9251.vkontakte.ru\/u804677\/a_7127ab0d.jpg\"},{\"uid\":916939,\"first_name\":\"Олюня\",\"last_name\":\"Тугузова\",\"sex\":\"1\",\"photo\":\"http:\/\/cs4239.vkontakte.ru\/u916939\/c_9bd90f10.jpg\",\"photo_medium\":\"http:\/\/cs4239.vkontakte.ru\/u916939\/b_2ffa9d6a.jpg\",\"photo_big\":\"http:\/\/cs4239.vkontakte.ru\/u916939\/a_121bb044.jpg\"},{\"uid\":1019187,\"first_name\":\"Владимир\",\"last_name\":\"Павкин\",\"sex\":\"2\",\"photo\":\"http:\/\/cs4125.vkontakte.ru\/u1019187\/c_5b74b302.jpg\",\"photo_medium\":\"http:\/\/cs4125.vkontakte.ru\/u1019187\/b_ba2b7ff9.jpg\",\"photo_big\":\"http:\/\/cs4125.vkontakte.ru\/u1019187\/a_6a130986.jpg\"},{\"uid\":1078903,\"first_name\":\"Лена\",\"last_name\":\"Мельян\",\"sex\":\"0\",\"photo\":\"http:\/\/cs9237.vkontakte.ru\/u1078903\/c_f3333d5b.jpg\",\"photo_medium\":\"http:\/\/cs9237.vkontakte.ru\/u1078903\/b_31d43791.jpg\",\"photo_big\":\"http:\/\/cs9237.vkontakte.ru\/u1078903\/a_0aec96fc.jpg\"},{\"uid\":1090604,\"first_name\":\"Денис\",\"last_name\":\"Гнатченко\",\"sex\":\"2\",\"photo\":\"http:\/\/cs9822.vkontakte.ru\/u1090604\/c_c923acc9.jpg\",\"photo_medium\":\"http:\/\/cs9822.vkontakte.ru\/u1090604\/b_cfe95445.jpg\",\"photo_big\":\"http:\/\/cs9822.vkontakte.ru\/u1090604\/a_436037d7.jpg\"},{\"uid\":1128823,\"first_name\":\"Никита\",\"last_name\":\"Любимов\",\"sex\":\"2\",\"photo\":\"http:\/\/cs4296.vkontakte.ru\/u1128823\/c_e252e82b.jpg\",\"photo_medium\":\"http:\/\/cs4296.vkontakte.ru\/u1128823\/b_b1406c81.jpg\",\"photo_big\":\"http:\/\/cs4296.vkontakte.ru\/u1128823\/a_fae69eb1.jpg\"},{\"uid\":1221733,\"first_name\":\"Алексей\",\"last_name\":\"Куличевский\",\"sex\":\"2\",\"photo\":\"http:\/\/cs10111.vkontakte.ru\/u1221733\/c_7e78cc07.jpg\",\"photo_medium\":\"http:\/\/cs10111.vkontakte.ru\/u1221733\/b_43eeea02.jpg\",\"photo_big\":\"http:\/\/cs10111.vkontakte.ru\/u1221733\/a_b619dea4.jpg\"},{\"uid\":1769588,\"first_name\":\"Наташа\",\"last_name\":\"Федькина\",\"sex\":\"1\",\"photo\":\"http:\/\/cs10011.vkontakte.ru\/u1769588\/c_d018db33.jpg\",\"photo_medium\":\"http:\/\/cs10011.vkontakte.ru\/u1769588\/b_a8ad508c.jpg\",\"photo_big\":\"http:\/\/cs10011.vkontakte.ru\/u1769588\/a_37193e1a.jpg\"},{\"uid\":1782653,\"first_name\":\"Ярина\",\"last_name\":\"Капко\",\"sex\":\"1\",\"photo\":\"http:\/\/cs9763.vkontakte.ru\/u1782653\/c_408eb384.jpg\",\"photo_medium\":\"http:\/\/cs9763.vkontakte.ru\/u1782653\/b_760b5ec3.jpg\",\"photo_big\":\"http:\/\/cs9763.vkontakte.ru\/u1782653\/a_e2266f2b.jpg\"},{\"uid\":2123481,\"first_name\":\"Константин\",\"last_name\":\"Бондарцов\",\"sex\":\"2\",\"photo\":\"http:\/\/cs4425.vkontakte.ru\/u2123481\/c_118b2917.jpg\",\"photo_medium\":\"http:\/\/cs4425.vkontakte.ru\/u2123481\/b_673c4841.jpg\",\"photo_big\":\"http:\/\/cs4425.vkontakte.ru\/u2123481\/a_720474da.jpg\"},{\"uid\":3213925,\"first_name\":\"Яна\",\"last_name\":\"Гареева\",\"sex\":\"0\",\"photo\":\"http:\/\/cs415.vkontakte.ru\/u3213925\/c_b0df9d97.jpg\",\"photo_medium\":\"http:\/\/cs415.vkontakte.ru\/u3213925\/b_97407639.jpg\",\"photo_big\":\"http:\/\/cs415.vkontakte.ru\/u3213925\/a_2a1c63dd.jpg\"},{\"uid\":3228617,\"first_name\":\"Анастасия\",\"last_name\":\"Погодина\",\"sex\":\"1\",\"photo\":\"http:\/\/cs10310.vkontakte.ru\/u3228617\/c_ccc2cd8c.jpg\",\"photo_medium\":\"http:\/\/cs10310.vkontakte.ru\/u3228617\/b_e191cb0a.jpg\",\"photo_big\":\"http:\/\/cs10310.vkontakte.ru\/u3228617\/a_1d579ac3.jpg\"},{\"uid\":3325611,\"first_name\":\"Ефанов\",\"last_name\":\"Филипп\",\"sex\":\"2\",\"photo\":\"http:\/\/cs4736.vkontakte.ru\/u3325611\/c_a28e23ca.jpg\",\"photo_medium\":\"http:\/\/cs4736.vkontakte.ru\/u3325611\/b_bd46ae0c.jpg\",\"photo_big\":\"http:\/\/cs4736.vkontakte.ru\/u3325611\/a_ac9f4bbd.jpg\"},{\"uid\":3496914,\"first_name\":\"Елена\",\"last_name\":\"Степченко\",\"sex\":\"1\",\"photo\":\"http:\/\/cs726.vkontakte.ru\/u3496914\/c_3c35c6dc.jpg\",\"photo_medium\":\"http:\/\/cs726.vkontakte.ru\/u3496914\/b_fd2b9603.jpg\",\"photo_big\":\"http:\/\/cs726.vkontakte.ru\/u3496914\/a_6215080d.jpg\"},{\"uid\":5393144,\"first_name\":\"Инна\",\"last_name\":\"Манаенкова\",\"sex\":\"1\",\"photo\":\"http:\/\/cs4537.vkontakte.ru\/u5393144\/c_7a3bda54.jpg\",\"photo_medium\":\"http:\/\/cs4537.vkontakte.ru\/u5393144\/b_fa8264bf.jpg\",\"photo_big\":\"http:\/\/cs4537.vkontakte.ru\/u5393144\/a_99e8ce1f.jpg\"},{\"uid\":7265902,\"first_name\":\"Максим\",\"last_name\":\"Шевчук\",\"sex\":\"2\",\"photo\":\"http:\/\/cs9689.vkontakte.ru\/u7265902\/c_effb08fe.jpg\",\"photo_medium\":\"http:\/\/cs9689.vkontakte.ru\/u7265902\/b_a5c25a48.jpg\",\"photo_big\":\"http:\/\/cs9689.vkontakte.ru\/u7265902\/a_bcc36206.jpg\"},{\"uid\":12701649,\"first_name\":\"Екатерина\",\"last_name\":\"Долина\",\"sex\":\"1\",\"photo\":\"http:\/\/cs9952.vkontakte.ru\/u12701649\/c_43204dff.jpg\",\"photo_medium\":\"http:\/\/cs9952.vkontakte.ru\/u12701649\/b_07259c9b.jpg\",\"photo_big\":\"http:\/\/cs9952.vkontakte.ru\/u12701649\/a_46b7efba.jpg\"},{\"uid\":14195642,\"first_name\":\"Kravtsova\",\"last_name\":\"Irka\",\"sex\":\"1\",\"photo\":\"http:\/\/cs9778.vkontakte.ru\/u14195642\/c_a0145968.jpg\",\"photo_medium\":\"http:\/\/cs9778.vkontakte.ru\/u14195642\/b_b5b8cbfa.jpg\",\"photo_big\":\"http:\/\/cs9778.vkontakte.ru\/u14195642\/a_d527da80.jpg\"},{\"uid\":14672890,\"first_name\":\"Кристиночка\",\"last_name\":\"Луговая\",\"sex\":\"1\",\"photo\":\"http:\/\/cs1431.vkontakte.ru\/u14672890\/c_69c7b317.jpg\",\"photo_medium\":\"http:\/\/cs1431.vkontakte.ru\/u14672890\/b_a0fb7f54.jpg\",\"photo_big\":\"http:\/\/cs1431.vkontakte.ru\/u14672890\/a_7705ccf5.jpg\"},{\"uid\":22003813,\"first_name\":\"Miss\",\"last_name\":\"Raubitch\",\"sex\":\"1\",\"photo\":\"http:\/\/cs9975.vkontakte.ru\/u22003813\/c_1160d81c.jpg\",\"photo_medium\":\"http:\/\/cs9975.vkontakte.ru\/u22003813\/b_3fec3a09.jpg\",\"photo_big\":\"http:\/\/cs9975.vkontakte.ru\/u22003813\/a_72c271e0.jpg\"},{\"uid\":22441933,\"first_name\":\"Dasha\",\"last_name\":\"Naletova\",\"sex\":\"1\",\"photo\":\"http:\/\/cs603.vkontakte.ru\/u22441933\/c_b2403c75.jpg\",\"photo_medium\":\"http:\/\/cs603.vkontakte.ru\/u22441933\/b_7517bfa2.jpg\",\"photo_big\":\"http:\/\/cs603.vkontakte.ru\/u22441933\/a_2c2e0ae0.jpg\"},{\"uid\":27544271,\"first_name\":\"Max\",\"last_name\":\"Daniloff\",\"sex\":\"2\",\"photo\":\"http:\/\/cs9935.vkontakte.ru\/u27544271\/c_c295f3d8.jpg\",\"photo_medium\":\"http:\/\/cs9935.vkontakte.ru\/u27544271\/b_f3538c5a.jpg\",\"photo_big\":\"http:\/\/cs9935.vkontakte.ru\/u27544271\/a_28f0f10a.jpg\"},{\"uid\":34230304,\"first_name\":\"Олег\",\"last_name\":\"Никулин\",\"sex\":\"2\",\"photo\":\"http:\/\/cs4665.vkontakte.ru\/u34230304\/c_81ab2367.jpg\",\"photo_medium\":\"http:\/\/cs4665.vkontakte.ru\/u34230304\/b_b363c579.jpg\",\"photo_big\":\"http:\/\/cs4665.vkontakte.ru\/u34230304\/a_807697e8.jpg\"},{\"uid\":37365548,\"first_name\":\"Екатерина\",\"last_name\":\"Герцен\",\"sex\":\"1\",\"photo\":\"http:\/\/cs9814.vkontakte.ru\/u37365548\/c_42ab7bc5.jpg\",\"photo_medium\":\"http:\/\/cs9814.vkontakte.ru\/u37365548\/b_3012ca73.jpg\",\"photo_big\":\"http:\/\/cs9814.vkontakte.ru\/u37365548\/a_36773a32.jpg\"},{\"uid\":46971894,\"first_name\":\"Катя\",\"last_name\":\"Решетникова\",\"sex\":\"1\",\"photo\":\"http:\/\/cs5111.vkontakte.ru\/u46971894\/c_754d2afe.jpg\",\"photo_medium\":\"http:\/\/cs5111.vkontakte.ru\/u46971894\/b_3c95628c.jpg\",\"photo_big\":\"http:\/\/cs5111.vkontakte.ru\/u46971894\/a_b9c0b41d.jpg\"},{\"uid\":51310648,\"first_name\":\"Сергей\",\"last_name\":\"Субботин\",\"sex\":\"2\",\"photo\":\"http:\/\/cs10306.vkontakte.ru\/u51310648\/c_20b967c3.jpg\",\"photo_medium\":\"http:\/\/cs10306.vkontakte.ru\/u51310648\/b_9f1b6bac.jpg\",\"photo_big\":\"http:\/\/cs10306.vkontakte.ru\/u51310648\/a_6438e022.jpg\"},{\"uid\":51553088,\"first_name\":\"Дмитрий\",\"last_name\":\"Оверчук\",\"sex\":\"2\",\"photo\":\"http:\/\/cs9346.vkontakte.ru\/u51553088\/c_41598b9b.jpg\",\"photo_medium\":\"http:\/\/cs9346.vkontakte.ru\/u51553088\/b_fa0dda31.jpg\",\"photo_big\":\"http:\/\/cs9346.vkontakte.ru\/u51553088\/a_9b4bde24.jpg\"},{\"uid\":57935381,\"first_name\":\"Олег\",\"last_name\":\"Козырев\",\"sex\":\"2\",\"photo\":\"http:\/\/cs4333.vkontakte.ru\/u57935381\/c_67a74cae.jpg\",\"photo_medium\":\"http:\/\/cs4333.vkontakte.ru\/u57935381\/b_8dba94fe.jpg\",\"photo_big\":\"http:\/\/cs4333.vkontakte.ru\/u57935381\/a_94095a01.jpg\"},{\"uid\":66361086,\"first_name\":\"Аврора\",\"last_name\":\"Bright\",\"sex\":\"1\",\"photo\":\"http:\/\/cs9572.vkontakte.ru\/u66361086\/c_82af5d8b.jpg\",\"photo_medium\":\"http:\/\/cs9572.vkontakte.ru\/u66361086\/b_c939ab2e.jpg\",\"photo_big\":\"http:\/\/cs9572.vkontakte.ru\/u66361086\/a_5e5ba3cc.jpg\"}]}}"
*/
            encode(apiR, false);
        }
    }

}


}