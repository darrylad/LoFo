import 'dart:math';

class ShowerThoughts {
  final List<String> _thoughts = [
    // "If you think about it, the brain named itself.",
    // "If you replace 'W' with 'T' in 'What, Where and When', you get the answer to each of them.",
    // "If you try to fail, and succeed, which have you done?",
    // "If you rip a hole in a net, there are actually fewer holes in it than there were before.",
    "Munchkin cats are known for their short legs, but they are also known for their short tempers.",

    "Jack Dawson could have fit on the door with Rose. But you wouldn't have remembered the movie as fondly as you do.",

    "Chiuwaawas are the cutest dogs.",

    "I eat six badaams daily",

    "Helmet \n- Hannah Baker",

    "It all started with a smile, that damned smile. \n- Hannah Baker",

    "Great design is as little design as possible. \n- Dieter Rams",

    "To improve is to change; to be perfect is to change often. \n- Winston Churchill",

    "Design is not just what it looks like and feels like. Design is how it works. \n- Steve Jobs",

    "Did you know that Hummingbirds are about the size of your thumb? ",

    "The only way to do great work is to love what you do. \n- Steve Jobs",

    "If you ever feel stupid, remember that Captain America tried to choke Ultron.",

    "🎵 He was distracted by, something else that crossed his, mind. \n So she went up to him and said \"What's the problem, boy?\" 🎵",

    "Rabbits are as dumb as they are cute.",

    "Developers, developers, developers, developers. \n- Steve Ballmer",

    "Finding your lost item is an internet connection away",

    "Cats are the best. 🐈",

    "Are you lighnting? Because you're McQueen.",

    "You've been called the Da Vinci of our time. What do you say to that? \n Absolutely ridiculous. I don't paint.",

    "Aluminium. \n- Jony Ive",

    "Roses are read, \n Violets are blue, \n Your internet's dead, \n Why? I have no clue.",
  ];

  String getThought() {
    return _thoughts[Random().nextInt(_thoughts.length)];
  }
}
