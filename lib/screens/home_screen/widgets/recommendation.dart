import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:onpods/utils/colors.dart';

class Recommendation extends StatefulWidget {
  const Recommendation({super.key});

  @override
  State<Recommendation> createState() => _RecommendationState();
}

class _RecommendationState extends State<Recommendation> {
  List data = [
    {
      "title": "SmartLess",
      "author":"sai kumar kusangi",
      "profile_pic":
          'https://cdn.hswstatic.com/gif/play/0b7f4e9b-f59c-4024-9f06-b3dc12850ab7-1920-1080.jpg',
      "image":
          "https://i.iheart.com/v3/url/aHR0cHM6Ly9jb250ZW50LnByb2R1Y3Rpb24uY2RuLmFydDE5LmNvbS9pbWFnZXMvMWIvZDcvOWUvMjIvMWJkNzllMjItNTQ4YS00Y2Y0LWJhYjctNzIwMmYzMjI5MzhjL2M4MGY5MDhmNzM3NmIxMmQ2MjNiYmE5ZjUyYmQzOTZkODliNTA2ODQ4NjhjOWIxOTNlNjlkNDQ3Mjg1NDE1NTE3YTgwNDk4M2FjYmFjYmE0NzA4Y2FhZTBmNzQzNmNhYThjYjlhZTczMDI5Y2NmOGIxYThhOTllZjg3Yzk4OGZkLmpwZWc?ops=fit(960%2C960)",
    },
    {
      "profile_pic":
          'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8cGVyc29ufGVufDB8fDB8fHww&w=1000&q=80',
      "title": "Dear Alana",
      "author":"Darshana",
      "image":
          "https://i.iheart.com/v3/url/aHR0cHM6Ly93d3cub21ueWNvbnRlbnQuY29tL2QvcHJvZ3JhbXMvZTczYzk5OGUtNmU2MC00MzJmLTg2MTAtYWUyMTAxNDBjNWIxL2VkZjhkYTZmLTQxYmItNGMwZi04OWIxLWIwNTAwMTZkZjdiNC9pbWFnZS5qcGc_dD0xNjkyMzA0MjAzJnNpemU9TGFyZ2U?ops=fit(960%2C960)"
    },
    {
      "image":'https://i.iheart.com/v3/url/aHR0cHM6Ly93d3cub21ueWNvbnRlbnQuY29tL2QvcHJvZ3JhbXMvZTczYzk5OGUtNmU2MC00MzJmLTg2MTAtYWUyMTAxNDBjNWIxLzA1MTFmMTNlLTQ3ZGYtNGQzYS05NzgzLWFlMjgwMDUzMjY3Yi9pbWFnZS5qcGc_dD0xNjkyMjkxMDQ4JnNpemU9TGFyZ2U?ops=fit(960%2C960)',
      "title":'Just B with Bethenny Frankel',
      "author":"Bethenny Frankel",
      "profile_pic":'https://images.healthshots.com/healthshots/en/uploads/2020/12/08182549/positive-person.jpg'
    }
  ];
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 15),
          child: Text(
            'Based on your interests',
            style: TextStyle(color: Colors.white, fontSize: 22),
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        SizedBox(
          height: 0.2.sh,
          child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: data.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Container(
                      width: 0.7.sw,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: primaryColor,
                          image: DecorationImage(
                              image: NetworkImage(
                                data[index]['image'],
                              ),
                              fit: BoxFit.cover)),
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topCenter,
                                      colors: [
                                    Colors.black,
                                    Colors.black26,
                                  ])),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: ListTile(
                                                       
                                horizontalTitleGap: 6,
                                leading: CircleAvatar(
                                  radius: 15,
                                  backgroundImage: NetworkImage(data[index]['profile_pic'])),
                                title: Text(
                                  data[index]['title'],
                                   maxLines: 1,
                                  style: const TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                      color: Colors.white, fontSize: 18),
                                ),
                                
                                subtitle: Text(
                                  
                                  data[index]['author'],
                                  maxLines: 1,
                                  style: TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                      color: Colors.white.withOpacity(0.6), fontSize: 14),
                                ),
                                trailing:Image.network('https://img.icons8.com/?size=512&id=VemyrWc1nD1j&format=png',width: 45,),
                              ),
                            ),
                          )
                        ],
                      )),
                );
              }),
        )
        // RecommendationSkeleton()
      ],
    );
  }
}
