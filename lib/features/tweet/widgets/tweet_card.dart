import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/common/common.dart';
import 'package:twitter_clone/constants/constants.dart';
import 'package:twitter_clone/core/enums/tweet_type_enum.dart';
import 'package:twitter_clone/features/auth/controller/auth_controller.dart';
import 'package:twitter_clone/features/tweet/widgets/hashtag_text.dart';
import 'package:twitter_clone/features/tweet/widgets/tweet_icon_button.dart';
import 'package:twitter_clone/models/tweet_model.dart';
import 'package:twitter_clone/theme/theme.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'carousel_image.dart';

class TweetCard extends ConsumerWidget {
  final Tweet tweet;
  const TweetCard({required this.tweet, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(userDetailsProvider(tweet.uid)).when(
          data: (user) => Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.all(10),
                    child: CircleAvatar(
                      radius: 35,
                      backgroundImage: NetworkImage(user.profilePic),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(right: 5),
                              child: Text(
                                user.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 19,
                                ),
                              ),
                            ),
                            Text(
                              "@${user.name} \u00B7 ${timeago.format(
                                tweet.tweetedAt,
                                locale: "en_short",
                              )}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Pallete.greyColor,
                                fontSize: 17,
                              ),
                            ),
                          ],
                        ),
                        HashtagText(text: tweet.text),
                        if (tweet.tweetType == TweetType.image)
                          CarouselImage(
                            imageLinks: tweet.imageLinks,
                          ),
                        if (tweet.link.isNotEmpty) ...[
                          const SizedBox(
                            height: 4,
                          ),
                          AnyLinkPreview(
                            link: "https://${tweet.link}",
                            displayDirection: UIDirection.uiDirectionHorizontal,
                          ),
                        ],
                        Container(
                          margin: EdgeInsets.only(
                            top: 10,
                            right: 20,
                          ),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TweetIconButton(
                                  pathName: AssetsConstants.viewsIcon,
                                  text: (tweet.commentIds.length +
                                          tweet.reshareCount +
                                          tweet.likes.length)
                                      .toString(),
                                  onTap: () {},
                                ),
                                TweetIconButton(
                                  pathName: AssetsConstants.commentIcon,
                                  text: tweet.commentIds.length.toString(),
                                  onTap: () {},
                                ),
                                TweetIconButton(
                                  pathName: AssetsConstants.retweetIcon,
                                  text: tweet.reshareCount.toString(),
                                  onTap: () {},
                                ),
                                TweetIconButton(
                                  pathName: AssetsConstants.likeFilledIcon,
                                  text: tweet.likes.length.toString(),
                                  onTap: () {},
                                ),
                              ]),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          error: (error, stackTrace) => ErrorText(
            error: error.toString(),
          ),
          loading: () => const Loader(),
        );
  }
}
