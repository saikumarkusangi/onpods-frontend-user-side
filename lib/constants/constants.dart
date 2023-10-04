import 'package:flutter/material.dart';

const String baseUrl = "https://onpods-serverless.vercel.app/v1";
const String pixelApiKey =
    "byPpLpRCY3WRCih9PAG0xnVWLdtvSDJ6m33R2uMfqTzFmuvzAgKSWShG";

  final List<Color> placeholderColors = [
    Colors.red.shade200,
    Colors.blue.shade200,
    Colors.green.shade200,
    Colors.yellow.shade200,
    Colors.orange.shade200,
    Colors.purple.shade200,
    // Add more colors as needed
  ];

final List data = [
  {
    "title": "You Feeling This",
    "image": "https://m.media-amazon.com/images/I/513kSILW8TL._SL500_.jpg",
    'des':
        'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.',
  },
  {
    "image":
        "https://i.pinimg.com/564x/13/bd/79/13bd79ec47e8713d669595ad134355d9.jpg",
    "title": "Breaking Brand",
    "des": "Lorem lroreme lorem lorem lorem"
  },
  {
    "title": "Stand Up Comedy",
    "image":
        "https://i.pinimg.com/564x/37/a5/92/37a5922f0b787878f6114b86cd94c630.jpg",
    "des":
        "Stuff You Should Know is a podcast that educates you on various topics."
  },
  {
    "title": "Sieu lua sieu lay",
    "des":
        "Stuff You Should Know is a podcast that educates you on various topics.",
    "image":
        'https://i.pinimg.com/564x/f7/0a/7a/f70a7a59ef85b00ee6ed489e47711a26.jpg',
  },
  {
    'des':
        'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.',
    "title": "The Mantawauk Caves",
    "image":
        "https://media-prod.fangoria.com/images/TheMantawaukCaves-Logo-FINAL3000x3000.width-800.jpg"
  },
  {
    'des':
        'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.',
    "image":
        'https://upload.wikimedia.org/wikipedia/en/9/94/StuffYouShouldKnow.jpg',
    "title": 'Stuff You Should Know',
  },
];

final List soundEffects = [
  {
    'category': 'Animals',
    'data': [
      {
        'id': '3',
        'icon': "https://img.icons8.com/?size=50&id=Hy6X0DME1x74&format=png",
        'name': "Dog Bark",
        'sound': 'https://assets.mixkit.co/active_storage/sfx/1/1-preview.mp3'
      },
      {
        'id': '4',
        'icon': "https://img.icons8.com/?size=64&id=49048&format=png",
        'name': "Cat Meow",
        'sound': 'https://assets.mixkit.co/active_storage/sfx/93/93-preview.mp3'
      },{
        'id':'5',
        'icon':'https://img.icons8.com/?size=50&id=4538&format=png',
        'sound':'https://assets.mixkit.co/active_storage/sfx/81/81-preview.mp3?play5600=',
        'name':'Horse neighing'
      },{
        'id':'6',
        'icon':'https://img.icons8.com/?size=50&id=3461&format=png',
        'sound':'https://audio-previews.elements.envatousercontent.com/files/95226306/preview.mp3?response-content-disposition=attachment%3B+filename%3D%22HVC57LD-stallion-horse.mp3%22&play5600=',
        'name':'Horse gallop'
      }
    ]
  },
  {
    'category':'Climate',
    'data':[
       {
    'id':'7',
    'icon':"https://img.icons8.com/?size=50&id=656&format=png",
     'name':"City Rain",
     'sound':'https://assets.mixkit.co/active_storage/sfx/2678/2678-preview.mp3'
  },
   {
    'id':'8',
    'icon':"https://img.icons8.com/?size=50&id=6703&format=png",
     'name':"Thunder",
     'sound':'https://assets.mixkit.co/active_storage/sfx/1297/1297-preview.mp3?play5600='
  },
    ]
  },
  {
    'category':'Action',
    'data':[
      {
        'id':'9',
        'name':'Gun Fire',
        'icon':'https://img.icons8.com/?size=50&id=37832&format=png',
        'sound':''
      },
        {
        'id':'10',
        'name':'FireWorks',
        'icon':'https://img.icons8.com/?size=50&id=39123&format=png',
        'sound':'https://cdn.pixabay.com/audio/2022/03/14/audio_a791c6fdc8.mp3?play5600='
      },
       {
        'id':'11',
        'name':'Bomb',
        'icon':'https://img.icons8.com/?size=50&id=39123&format=png',
        'sound':'https://cdn.pixabay.com/audio/2022/03/14/audio_a791c6fdc8.mp3?play5600='
      },
      {
        'id':'12',
        'sound':'https://cdn.pixabay.com/audio/2022/10/25/audio_6646cc790f.mp3?play5600=',
        'name':'Nuclear Alaram',
        'icon':'https://img.icons8.com/?size=50&id=55212&format=png'
      }
   
    ]
  }
];
