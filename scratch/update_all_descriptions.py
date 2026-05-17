# -*- coding: utf-8 -*-
import json
import re
import os

# 1. Define description generator
def get_vietnamese_description(ten_hh, ma_loai):
    name_lower = ten_hh.lower()
    
    # Category 1001: Laptop
    if ma_loai == 1001:
        if "dell" in name_lower:
            return "Laptop Dell sở hữu thiết kế tối giản, bộ khung vỏ chắc chắn đạt tiêu chuẩn độ bền quân đội. Được trang bị cấu hình phần cứng mạnh mẽ với vi xử lý Intel Core hiệu năng cao, dung lượng RAM lớn và ổ cứng SSD tốc độ cao, máy đáp ứng hoàn hảo từ các tác vụ văn phòng, lập trình kỹ thuật chuyên sâu cho đến nhu cầu học tập và giải trí đa phương tiện mượt mà."
        elif "hp" in name_lower:
            return "Laptop HP sở hữu vẻ ngoài thanh lịch thời thượng với tông màu bạc sang trọng, các đường nét thiết kế tinh tế và viền màn hình siêu mỏng sắc nét. Cấu hình mạnh mẽ mang lại trải nghiệm làm việc năng suất vượt trội, bàn phím gõ cực kỳ êm ái cùng thời lượng pin bền bỉ, là sự lựa chọn lý tưởng cho doanh nhân, nhân viên văn phòng và các bạn sinh viên."
        elif "asus" in name_lower:
            return "Laptop ASUS nổi bật với ngôn ngữ thiết kế hiện đại, trẻ trung và vô cùng mỏng nhẹ, cực kỳ thuận tiện cho việc di chuyển hàng ngày. Màn hình độ phân giải cao hiển thị màu sắc sống động, bộ vi xử lý tối ưu hiệu năng cùng hệ thống tản nhiệt thông minh hoạt động êm ái, mang lại trải nghiệm sử dụng trọn vẹn cho cả công việc và giải trí."
        elif "msi" in name_lower:
            return "Laptop MSI được thiết kế tối ưu cho hiệu năng đồ họa chuyên nghiệp và trải nghiệm gaming đỉnh cao. Máy sở hữu ngoại hình hầm hố cá tính, trang bị card đồ họa rời mạnh mẽ, hệ thống tản nhiệt Cooler Boost độc quyền cực mát cùng màn hình tần số quét cao siêu mượt, là trợ thủ đắc lực cho các game thủ và nhà sáng tạo nội dung."
        elif "toshiba" in name_lower:
            return "Laptop Toshiba nổi tiếng với độ bền vượt trội theo thời gian và sự ổn định cao trong vận hành. Máy sở hữu thiết kế chắc chắn, bàn phím tiêu chuẩn gõ êm và cấu hình tối ưu tốt cho mọi tác vụ văn phòng cơ bản, duyệt web, xử lý dữ liệu và học tập hàng ngày."
        else:
            return "Laptop cao cấp chính hãng sở hữu cấu hình mạnh mẽ, thiết kế mỏng nhẹ sang trọng và thời trang. Màn hình sắc nét chống chói bảo vệ mắt, hiệu năng xử lý mượt mà mọi tác vụ học tập, văn phòng và giải trí hàng ngày."
            
    # Category 1000: Đồng hồ (Watch)
    elif ma_loai == 1000:
        if "swatch" in name_lower:
            return "Đồng hồ Thụy Sỹ Swatch nổi bật với ngôn ngữ thiết kế trẻ trung, phối màu cá tính và thời trang độc đáo. Sử dụng bộ máy Quartz Thụy Sỹ đo giờ chính xác tuyệt đối, vỏ chất liệu cao cấp nhẹ nhàng cùng khả năng chống nước tốt, đây là món phụ kiện hoàn hảo để tôn lên phong cách năng động và hiện đại của bạn."
        elif "tissot" in name_lower:
            return "Đồng hồ Thụy Sỹ Tissot danh tiếng lâu đời, mang phong cách thiết kế sang trọng, lịch lãm đầy lôi cuốn của giới thượng lưu. Trang bị mặt kính Sapphire nguyên khối chống trầy xước hoàn hảo, bộ máy Automatic cơ khí tinh xảo hoạt động bền bỉ, là biểu tượng đẳng cấp dành riêng cho quý ông và quý bà thành đạt."
        elif "citizen" in name_lower:
            return "Đồng hồ Citizen tích hợp công nghệ Eco-Drive độc quyền giúp hấp thu và chuyển hóa mọi nguồn sáng thành năng lượng hoạt động, hoàn toàn không cần thay pin. Thiết kế tinh xảo với vỏ thép không gỉ cao cấp, mặt kính chống xước cùng khả năng chống nước vượt trội, mang lại vẻ ngoài lịch lãm và nam tính mạnh mẽ."
        elif "michael kors" in name_lower:
            return "Đồng hồ Michael Kors thời trang Mỹ thời thượng với thiết kế mạ vàng hồng quý phái, viền đính đá Swarovski lấp lánh sang trọng. Đây là món trang sức hoàn hảo tôn vinh vẻ đẹp kiều diễm, thanh lịch và kiêu kỳ của phái đẹp trong mọi bữa tiệc và sự kiện quan trọng."
        elif "tag heuer" in name_lower:
            return "Đồng hồ TAG Heuer thể thao cao cấp từ Thụy Sỹ, sở hữu thiết kế cơ khí mạnh mẽ nam tính với vòng Bezel xoay Chronograph thể thao năng động. Bộ máy cơ học tinh xảo đạt độ chính xác cực cao, vỏ thép không gỉ chống va đập và chống nước độ sâu vượt trội, dành riêng cho những quý ông đam mê tốc độ và sự chinh phục."
        elif "luminox" in name_lower:
            return "Đồng hồ chuyên dụng quân đội siêu bền bỉ Luminox, vỏ chất liệu carbon siêu nhẹ chống sốc và chịu va đập cực tốt. Trang bị công nghệ ống khí tự phát sáng liên tục suốt 25 năm bất kể điều kiện ánh sáng, khả năng chống nước cực cao, được tin dùng bởi lực lượng đặc nhiệm Navy SEAL."
        elif "g-shock" in name_lower:
            return "Đồng hồ Casio G-Shock huyền thoại với cấu trúc chống va đập, chống sốc và chống nước ở độ sâu 200m vượt trội. Thiết kế thể thao hầm hố, tích hợp các tính năng thông minh như giờ thế giới, bấm giờ thể thao, báo thức và đèn LED cực sáng, mang lại độ bền bỉ bất chấp thời gian."
        elif "pro trek" in name_lower:
            return "Đồng hồ chuyên thám hiểm dã ngoại Casio Pro Trek tích hợp công nghệ Tough Solar tự động sạc bằng năng lượng mặt trời. Máy trang bị bộ ba cảm biến (Triple Sensor) gồm la bàn số, đo áp suất/độ cao và nhiệt độ vô cùng chính xác, là người bạn đồng hành hoàn hảo cho những chuyến leo núi, phượt dã ngoại chuyên nghiệp."
        else:
            return "Đồng hồ thời trang cao cấp chính hãng, thiết kế sang trọng tinh tế tinh xảo đến từng chi tiết. Sử dụng bộ máy hoạt động chính xác bền bỉ, mặt kính chống xước tốt và khả năng chống nước cao, tôn lên phong cách thời thượng và đẳng cấp của người đeo."

    # Category 1002: Máy ảnh (Camera)
    elif ma_loai == 1002:
        if "powershot" in name_lower:
            return "Máy ảnh du lịch Canon PowerShot sở hữu thiết kế vô cùng nhỏ gọn, thời trang và tiện lợi. Trang bị cảm biến hình ảnh độ phân giải cao cùng khả năng zoom quang học mạnh mẽ, tích hợp các chế độ chụp tự động thông minh và quay phim Full HD sắc nét, cực kỳ thích hợp để lưu giữ những khoảnh khắc đẹp trong mọi chuyến đi."
        elif "coolpix" in name_lower:
            return "Máy ảnh compact Nikon COOLPIX siêu mỏng nhẹ thời thượng với nhiều phiên bản màu sắc nổi bật. Sử dụng ống kính NIKKOR cao cấp lấy nét siêu nhanh, tích hợp công nghệ chống rung quang học xuất sắc giúp bạn dễ dàng ghi lại những bức ảnh gia đình và bạn bè sắc nét, tươi sáng nhất."
        elif "dslr" in name_lower or "d7000" in name_lower or "d3100" in name_lower:
            return "Máy ảnh bán chuyên nghiệp DSLR Nikon sở hữu cảm biến ảnh lớn, chip xử lý hình ảnh tốc độ cao mang lại chất lượng ảnh chuyên nghiệp tuyệt vời. Khả năng lấy nét tự động cực nhanh, dải ISO rộng chụp thiếu sáng xuất sắc cùng khả năng thay đổi ống kính linh hoạt, đáp ứng mọi đam mê sáng tạo nhiếp ảnh."
        elif "fujifilm" in name_lower:
            return "Máy ảnh Fujifilm sở hữu thiết kế cổ điển sang trọng cùng công nghệ giả lập màu phim trứ danh độc quyền. Ảnh chụp có độ chi tiết rất cao, màu sắc mang đậm tính nghệ thuật cổ điển, lấy nét tự động nhanh chóng và chính xác, lý tưởng cho những ai yêu thích nhiếp ảnh đường phố."
        elif "lumix" in name_lower or "panasonic" in name_lower:
            return "Máy ảnh Panasonic LUMIX dòng compact cao cấp, trang bị ống kính Leica danh tiếng thế giới. Máy cho chất lượng quay phim và chụp ảnh sắc nét, dải tương phản động rộng cùng hệ thống chống rung quang học 5 trục hiện đại, phong cách gọn nhẹ tiện dụng."
        else:
            return "Máy ảnh kỹ thuật số chính hãng, cảm biến độ phân giải cao cho hình ảnh sắc nét chi tiết. Tích hợp nhiều chế độ chụp ảnh thông minh, lấy nét tự động cực nhanh và chống rung quang học, giúp bạn dễ dàng lưu giữ mọi khoảnh khắc đáng nhớ."

    # Category 1004: Nước hoa (Fragrance)
    elif ma_loai == 1004:
        if "guess" in name_lower:
            return "Nước hoa Guess dành cho phái đẹp mang hương thơm thanh mát ngọt ngào đầy quyến rũ. Sự kết hợp tinh tế từ hương quả mọng tươi trẻ, hoa mẫu đơn thanh lịch ở tầng hương giữa và gỗ ấm áp xạ hương ở tầng hương cuối tạo nên một phong cách thanh lịch, quyến rũ và đầy lôi cuốn."
        elif "dolce" in name_lower or "gabbana" in name_lower:
            return "Nước hoa cao cấp Dolce & Gabbana Light Blue mang hương thơm phóng khoáng, tươi mát tràn đầy năng lượng tươi trẻ của biển Địa Trung Hải. Sự hòa quyện hoàn hảo giữa chanh vàng Ý tươi mát, táo xanh giòn ngọt kết hợp cùng gỗ tuyết tùng ấm áp, mang lại hương thơm sảng khoái suốt cả ngày."
        elif "paris hilton" in name_lower:
            return "Nước hoa Paris Hilton mang phong cách ngọt ngào, gợi cảm và vô cùng quyến rũ, kiêu sa. Hương thơm chủ đạo là sự kết hợp ngọt lịm từ dưa gang nhiệt đới, đào mọng cùng hương các loài hoa sang quý, thích hợp cho những buổi hẹn hò lãng mạn hoặc tiệc đêm sang trọng."
        elif "britney spears" in name_lower or "fantasy" in name_lower:
            return "Nước hoa Britney Spears Fantasy mang phong cách ngọt ngào lãng mạn đầy mê hoặc như một câu chuyện cổ tích. Tông hương chủ đạo ngọt ngào dễ thương từ sô cô la trắng, bánh cupcake kết hợp tinh tế cùng hoa nhài quyến rũ và gỗ đàn hương, độ lưu hương cực tốt."
        elif "calvin klein" in name_lower or "ck" in name_lower:
            return "Nước hoa Calvin Klein Eternity mang phong cách cổ điển, ấm áp, sâu lắng đầy mạnh mẽ nam tính. Tông hương tinh tế mở đầu với oải hương, hương thảo mộc thanh mát, tiếp nối bằng hương gỗ đàn hương và hổ phách ấm áp ở tầng hương cuối, tôn vinh vẻ lịch lãm trưởng thành."
        elif "nautica" in name_lower:
            return "Nước hoa Nautica Blue mang hương thơm đại dương xanh mát, sảng khoái và tràn đầy năng lượng nam tính mạnh mẽ. Tông hương mát lạnh của cam chanh quyện cùng gỗ tuyết tùng và xạ hương, cực kỳ thích hợp cho các hoạt động thể thao ngoài trời và sử dụng trong mùa hè nóng bức."
        else:
            return "Nước hoa cao cấp chính hãng mang hương thơm sang trọng, quyến rũ độc đáo với độ lưu hương lâu dài và tỏa hương tinh tế. Sự kết hợp hoàn hảo từ các nguyên liệu thiên nhiên quý hiếm giúp bạn tự tin khẳng định cá tính riêng biệt của mình."

    # Category 1005: Trang sức (Jewelry)
    elif ma_loai == 1005:
        if "opal" in name_lower:
            return "Nhẫn bạc đính đá Opal trắng tự nhiên với ánh ngũ sắc xà cừ kỳ diệu lấp lánh thay đổi theo góc nhìn, kết hợp cùng các viên đá kim cương nhân tạo CZ tinh xảo. Món trang sức phong thủy mang lại may mắn, bình an, đồng thời tôn lên vẻ đẹp kiêu sa, quý phái của chủ nhân."
        elif "celtic" in name_lower or "knot" in name_lower:
            return "Nhẫn bạc Celtic Knot mang ngôn ngữ thiết kế nút thắt vô tận độc đáo của người Ireland cổ đại, biểu tượng cho tình yêu vĩnh cửu và sự gắn kết vô tận. Nhẫn chế tác tinh xảo từ chất liệu bạc Sterling 925 sáng bóng, phong cách thanh lịch, tinh tế thích hợp đeo hàng ngày."
        elif "solitaire" in name_lower or "diamond" in name_lower:
            return "Nhẫn bạc đính viên đá Solitaire Diamond CZ nhô cao cổ điển lấp lánh tuyệt đẹp thu hút mọi ánh nhìn. Nhẫn được thiết kế tinh xảo, là minh chứng tuyệt vời cho tình yêu đôi lứa bền chặt và là món quà hoàn hảo nhất cho các buổi lễ đính hôn, kỷ niệm đặc biệt."
        elif "moonstone" in name_lower:
            return "Nhẫn bạc đính đá Moonstone (đá mặt trăng) mang ánh sáng xà cừ huyền ảo dịu nhẹ đầy cuốn hút dưới ánh đèn. Thiết kế nhẫn thanh mảnh kết hợp ổ nhẫn bạc 925 chế tác tỉ mỉ, mang lại vẻ đẹp dịu dàng thanh tao, mang hơi hướng tâm linh may mắn cho phái đẹp."
        elif "amber" in name_lower:
            return "Nhẫn bạc đính đá hổ phách Amber tự nhiên màu cam mật ong ấm áp quý phái, mang ý nghĩa thu hút tài lộc, sức khỏe và sự thịnh vượng. Thiết kế nhẫn sang trọng, cổ điển độc bản, vô cùng nổi bật khi kết hợp cùng trang phục dạ tiệc."
        elif "claddagh" in name_lower:
            return "Nhẫn Claddagh truyền thống của Ireland với biểu tượng hai bàn tay nâng niu trái tim đội vương miện, tượng trưng cho tình bạn chân thành, tình yêu nồng cháy và lòng trung thành tuyệt đối. Chế tác tinh xảo từ bạc 925 cao cấp."
        else:
            return "Nhẫn bạc trang sức cao cấp chính hãng đính đá quý tinh xảo, sáng bóng bền đẹp thời gian. Thiết kế thời trang thời thượng sang trọng tinh tế, là món phụ kiện trang sức không thể thiếu tôn vinh vẻ đẹp thanh lịch và cuốn hút của bạn."

    # Category 1006: Giày (Shoes)
    elif ma_loai == 1006:
        if "tuyết" in name_lower or "winter" in name_lower or "snow" in name_lower:
            return "Giày bốt đi tuyết cao cổ chuyên dụng, chất liệu da chống thấm nước tuyệt đối kết hợp lớp lót lông cừu dày dặn, ấm áp mềm mại giúp giữ ấm đôi bàn chân hoàn hảo dưới thời tiết giá lạnh. Đế cao su chịu lực với rãnh chống trượt sâu, vô cùng an toàn khi di chuyển."
        elif "ugg" in name_lower:
            return "Giày bốt lông cừu UGG thời trang cổ ngắn cực kỳ cá tính với thiết kế đính khuy tiện lợi, chất liệu da lộn mềm mại cao cấp. Lớp lông cừu tự nhiên dày ấm bên trong đem lại cảm giác êm ái tối đa cho từng bước đi, phong cách trẻ trung năng động thích hợp cho mùa đông dạo phố."
        elif "sorel" in name_lower:
            return "Giày bốt dã ngoại Sorel chống nước hoàn hảo với cổ giày lót lông ấm áp, chất liệu cao su đúc nguyên khối chống thấm bền bỉ. Thiết kế thể thao khỏe khoắn năng động, đế bám cực tốt chống trơn trượt hiệu quả, chuyên dụng cho hoạt động leo núi, dã ngoại thời tiết xấu."
        else:
            return "Giày bốt thời trang cao cấp, chất liệu da mềm mại êm chân và giữ ấm hiệu quả. Thiết kế phom dáng ôm chân hiện đại, đế cao su chống trượt bền chắc, đem lại sự tự tin và thoải mái tối đa cho bạn trên mỗi bước chân."

    # Category 1007: Vali (Luggage)
    elif ma_loai == 1007:
        if "samsonite" in name_lower:
            return "Vali Samsonite cao cấp siêu bền bỉ, chế tác từ chất liệu Polycarbonate có khả năng đàn hồi cực cao chống bể vỡ và chống xước hoàn hảo. Trang bị khóa số bảo mật chuẩn quốc tế TSA an toàn, bánh xe đôi xoay 360 độ siêu êm ái giúp di chuyển nhẹ nhàng trên mọi địa hình."
        elif "osprey" in name_lower:
            return "Vali balo Osprey đa năng thông minh kết hợp hoàn hảo giữa balo phượt chuyên dụng và vali kéo tiện lợi. Chất liệu vải nylon chống rách siêu nhẹ chống thấm nước, quai đeo trợ lực thiết kế công thái học ôm sát lưng cùng tay kéo hợp kim chắc khỏe, là bạn đồng hành lý tưởng."
        elif "london fog" in name_lower:
            return "Vali kéo cao cấp London Fog mang phong cách cổ điển lịch lãm mang đậm chất hoàng gia Anh. Vali sử dụng chất liệu vải dệt họa tiết sang trọng kết hợp viền da cao cấp bền bỉ, khoang chứa rộng rãi chia ngăn thông minh cùng hệ thống bánh xe xoay 360 độ êm ái."
        elif "high sierra" in name_lower:
            return "Vali balo High Sierra đa năng năng động tích hợp ngăn chứa đồ thông minh siêu rộng rãi. Bánh xe kéo thể thao chắc khỏe di chuyển mượt mà kết hợp hệ thống quai đeo balo ẩn hiện linh hoạt, thích hợp cho các chuyến du lịch ngắn ngày, dã ngoại dạo phố."
        else:
            return "Vali du lịch cao cấp chính hãng siêu nhẹ và siêu bền bỉ. Khung vali chắc chắn chống va đập mạnh, thiết kế ngăn chứa rộng rãi tối ưu diện tích sắp xếp đồ đạc, khóa số bảo mật an toàn cùng bánh xe di chuyển êm ái linh hoạt."

    else:
        return "Sản phẩm cao cấp chất lượng vượt trội chính hãng, được đông đảo khách hàng tin dùng lựa chọn. Thiết kế tiện dụng hiện đại, chất liệu bền bỉ an toàn, mang lại trải nghiệm sử dụng hoàn hảo và giá trị bền vững cho cuộc sống của bạn."

# 2. Robust SQL Values Tokenizer
def parse_sql_values(vals_str):
    tokens = []
    current = []
    in_quotes = False
    escaped = False
    i = 0
    while i < len(vals_str):
        c = vals_str[i]
        if in_quotes:
            if c == "'" and not escaped:
                # Check if it is a double single quote (SQL escape for single quote)
                if i + 1 < len(vals_str) and vals_str[i+1] == "'":
                    current.append("'")
                    i += 1  # Skip next quote
                else:
                    in_quotes = False
                    current.append("'")
            else:
                current.append(c)
        else:
            if c == "'":
                in_quotes = True
                current.append(c)
            elif c == ",":
                tokens.append("".join(current).strip())
                current = []
            else:
                current.append(c)
        i += 1
    tokens.append("".join(current).strip())
    return tokens

# 3. Update SQL File
def update_sql_file(file_path):
    print(f"Updating file: {file_path}")
    if not os.path.exists(file_path):
        print(f"File not found: {file_path}")
        return
        
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()
        
    lines = content.split('\n')
    updated_lines = []
    updated_count = 0
    
    for idx, line in enumerate(lines):
        if "INSERT [dbo].[HangHoa]" in line and "VALUES" in line:
            # Parse prefix and VALUES part
            parts = line.split("VALUES (")
            if len(parts) > 1:
                prefix = parts[0]
                suffix_part = parts[1]
                # Find the closing parenthesis of VALUES
                # Since VALUES is at the end, let's find the last ')'
                r_index = suffix_part.rfind(')')
                if r_index != -1:
                    vals_str = suffix_part[:r_index]
                    suffix = suffix_part[r_index:]
                    
                    # Parse tokens
                    tokens = parse_sql_values(vals_str)
                    if len(tokens) >= 11:
                        ma_hh = int(tokens[0].strip())
                        ten_hh = tokens[1].replace("N'", "'").strip("'").strip()
                        ma_loai = int(tokens[3].strip())
                        
                        # Generate description
                        desc = get_vietnamese_description(ten_hh, ma_loai)
                        
                        # Escape single quotes in description for SQL
                        desc_escaped = desc.replace("'", "''")
                        
                        # Update index 10 (MoTa)
                        tokens[10] = f"N'{desc_escaped}'"
                        
                        new_vals_str = ", ".join(tokens)
                        new_line = prefix + "VALUES (" + new_vals_str + suffix
                        updated_lines.append(new_line)
                        updated_count += 1
                        continue
            updated_lines.append(line)
        else:
            updated_lines.append(line)
            
    # Write back
    with open(file_path, 'w', encoding='utf-8') as f:
        f.write('\n'.join(updated_lines))
        
    print(f"Successfully updated {updated_count} HangHoa insert descriptions in {file_path}!")

# Run updates on SQL files
update_sql_file(r"h:\App\GitHub\QuaMonHaiFinalProject\HShopScript.sql")
update_sql_file(r"h:\App\GitHub\QuaMonHaiFinalProject\HShopScript_Combined.sql")

# 4. Connect to database to update live values (if accessible)
appsettings_path = r"h:\App\GitHub\QuaMonHaiFinalProject\appsettings.json"
try:
    with open(appsettings_path, 'r', encoding='utf-8') as f:
        config = json.load(f)
    conn_str = config["ConnectionStrings"]["Hshop2023ConnectionString"]
except Exception as e:
    conn_str = None

if conn_str:
    try:
        import pyodbc
        print("Connecting to live database to apply updates...")
        drivers = [x for x in pyodbc.drivers()]
        driver = None
        for d in ["ODBC Driver 18 for SQL Server", "ODBC Driver 17 for SQL Server", "SQL Server"]:
            if d in drivers:
                driver = d
                break
        
        if driver:
            p_conn_str = f"Driver={{{driver}}};" + conn_str
            conn = pyodbc.connect(p_conn_str, timeout=5)
            cursor = conn.cursor()
            
            # Fetch all HangHoa IDs, Names and Categories to match
            cursor.execute("SELECT MaHH, TenHH, MaLoai FROM HangHoa")
            rows = cursor.fetchall()
            
            db_updates = 0
            for r in rows:
                ma_hh = r[0]
                ten_hh = r[1]
                ma_loai = r[2]
                
                desc = get_vietnamese_description(ten_hh, ma_loai)
                cursor.execute("UPDATE HangHoa SET MoTa = ? WHERE MaHH = ?", (desc, ma_hh))
                db_updates += 1
                
            conn.commit()
            print(f"Successfully updated {db_updates} descriptions in the live database!")
            conn.close()
    except Exception as e:
        print("Failed to run live database update (Tunnel may be offline or blocked):", e)
        print("This is completely expected if the live database tunnel is offline. The local SQL script files have been updated successfully!")
