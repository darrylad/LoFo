import 'package:flutter/material.dart';
import 'package:lofo/backend/letter_card_info.dart';

String posterImagePath = 'assets/images/profileS.jpg';

// card id fomat : ex220003001@day/month/year/hour:minute:second

List<LetterCardInfo> databaseSecurityInbox = [
  LetterCardInfo(
    cardCategory: 0,
    cardID: 'ex220003001@4/3/24/11:52:40',
    cardPosterID: 'ex220003001@iiti.ac.in',
    cardPostedAt: DateTime.parse('2024-03-04 11:52:40.094'),
    cardTitle: 'Letter 1',
    cardDescription: 'This is a letter',
    cardLocation: 'Location 1',
    cardTimeLastSeen: 'Time 1',
    cardName: 'Name 1',
    cardImage:
        Image.asset('assets/images/photo-1643804926339-e94f0a655185.png'),
    userImage: Image.asset(posterImagePath),
  ),
  LetterCardInfo(
      cardCategory: 0,
      cardID: 'ex220003002@4/3/24/11:52:40',
      cardPosterID: 'ex220003002@iiti.ac.in',
      cardPostedAt: DateTime.parse('2024-03-04 11:52:40.094'),
      cardTitle:
          'Letter 2 Letter 2 Letter 2 Letter 2 Letter 2 Letter 2 Letter 2 Letter 2 Letter 2 Letter 2 Letter 2 Letter 2 Letter 2 Letter 2 Letter 2 Letter 2 Letter 2 Letter 2 Letter 2 Letter 2 Letter 2 ',
      cardDescription: 'This is a letter',
      cardLocation: 'Location 2',
      cardTimeLastSeen: 'Time 2',
      cardName: 'Name 2',
      cardImage:
          Image.asset('assets/images/photo-1643804926339-e94f0a655185.png'),
      userImage: Image.asset(posterImagePath)),
  LetterCardInfo(
      cardCategory: 0,
      cardID: 'ex220003003@4/3/24/11:52:40',
      cardPosterID: 'ex220003003@iiti.ac.in',
      cardPostedAt: DateTime.parse('2024-03-04 11:52:40.094'),
      cardTitle: 'Letter 3',
      cardDescription:
          'This is a letter. This is a letter. This is a letter. This is a letter. This is a letter. This is a letter.This is a letter. This is a letter.This is a letter. This is a letter.This is a letter. This is a letter.This is a letter. This is a letter.This is a letter. This is a letter.This is a letter. This is a letter.This is a letter. This is a letter.This is a letter. This is a letter.This is a letter. This is a letter.This is a letter. This is a letter.This is a letter. This is a letter.This is a letter. This is a letter.This is a letter. This is a letter.This is a letter. This is a letter.This is a letter. This is a letter.',
      cardLocation: 'Location 3',
      cardTimeLastSeen: 'Time 3',
      cardName: 'Name 3',
      cardImage:
          Image.asset('assets/images/photo-1643804926339-e94f0a655185.png'),
      userImage: Image.asset(posterImagePath)),
  LetterCardInfo(
      cardCategory: 0,
      cardID: 'ex220003004@4/3/24/11:52:40',
      cardPosterID: 'ex220003004@iiti.ac.in',
      cardPostedAt: DateTime.parse('2024-03-04 11:52:40.094'),
      cardTitle: 'Letter 4',
      cardDescription: 'This is a letter',
      cardLocation: 'Location 4',
      cardTimeLastSeen: 'Time 4',
      cardName: 'Name 4',
      cardImage: null,
      userImage: Image.asset(posterImagePath)),
  LetterCardInfo(
      cardCategory: 0,
      cardID: 'ex220003005@4/3/24/11:52:40',
      cardPosterID: 'ex220003005@iiti.ac.in',
      cardPostedAt: DateTime.parse('2024-03-04 11:52:40.094'),
      cardTitle: 'Letter 5',
      cardDescription: 'This is a letter',
      cardLocation: 'Location 5',
      cardTimeLastSeen: 'Time 5',
      cardName: 'Name 5',
      cardImage:
          Image.asset('assets/images/photo-1643804926339-e94f0a655185.png'),
      userImage: Image.asset(posterImagePath)),
  LetterCardInfo(
      cardCategory: 0,
      cardID: 'ex220003006@4/3/24/11:52:40',
      cardPosterID: 'ex220003006@iiti.ac.in',
      cardPostedAt: DateTime.parse('2024-03-04 11:52:40.094'),
      cardTitle: 'Letter 6',
      cardDescription: 'This is a letter',
      cardLocation: 'Location 6',
      cardTimeLastSeen: null,
      cardName: 'Name 6',
      cardImage:
          Image.asset('assets/images/photo-1643804926339-e94f0a655185.png'),
      userImage: Image.asset(posterImagePath)),
  LetterCardInfo(
      cardCategory: 0,
      cardID: 'ex220003007@4/3/24/11:52:40',
      cardPosterID: 'ex220003007@iiti.ac.in',
      cardPostedAt: DateTime.parse('2024-03-04 11:52:40.094'),
      cardTitle: 'Letter 7',
      cardDescription: 'This is a letter',
      cardLocation: 'Location 7',
      cardTimeLastSeen: 'Time 7',
      cardName: 'Name 7',
      cardImage:
          Image.asset('assets/images/photo-1643804926339-e94f0a655185.png'),
      userImage: Image.asset(posterImagePath)),
];
