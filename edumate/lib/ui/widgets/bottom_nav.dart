part of 'widgets.dart';

class BottomNavigation extends StatelessWidget {
  final int index;
  final bool isReel;

  const BottomNavigation({Key? key, required this.index, this.isReel = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      decoration: BoxDecoration(
          color: isReel ? Colors.black : Colors.white,
          boxShadow: const [
            BoxShadow(color: Colors.grey, blurRadius: 9, spreadRadius: -4)
          ]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _ItemButtom(
            i: 1,
            index: index,
            icon: Icons.home_outlined,
            isReel: isReel,
            onPressed: () => Navigator.pushAndRemoveUntil(
                context, routeSlide(page: HomeScreen()), (_) => false),
          ),
          _ItemButtom(
            i: 3,
            index: index,
            icon: Icons.note_outlined,
            isReel: isReel,
            onPressed: () => Navigator.pushAndRemoveUntil(
                context, routeSlide(page: NotesScreen()), (_) => false),
          ),
          _ItemButtom(
            i: 4,
            index: index,
            icon: Icons.library_books_outlined,
            isReel: isReel,
            onPressed: () => Navigator.pushAndRemoveUntil(
                context, routeSlide(page: FlashCardScreen()), (_) => false),
          ),
          _ItemButtom(
            i: 5,
            index: index,
            icon: Icons.settings_outlined,
            isReel: isReel,
            onPressed: () => Navigator.pushAndRemoveUntil(context,
                routeSlide(page: ReminderSettingsScreen()), (_) => false),
          ),
          _ItemButtom(
            i: 6,
            index: index,
            icon: Icons.quiz_outlined,
            isReel: isReel,
            onPressed: () => Navigator.pushAndRemoveUntil(
                context, routeSlide(page: QuizzScreen()), (_) => false),
          ),
          _ItemButtom(
            i: 7,
            index: index,
            icon: Icons.scanner_outlined,
            isReel: isReel,
            onPressed: () => Navigator.pushAndRemoveUntil(
                context, routeSlide(page: ScanScreen()), (_) => false),
          ),
          _ItemButtom(
            i: 8,
            index: index,
            icon: Icons.article_outlined,
            isReel: isReel,
            onPressed: () => Navigator.pushAndRemoveUntil(
                context, routeSlide(page: UploadFileScreen()), (_) => false),
          ),
          _ItemButtom(
            i: 9,
            index: index,
            icon: Icons.person_2_outlined,
            isReel: isReel,
            onPressed: () => Navigator.pushAndRemoveUntil(
                context, routeSlide(page: ProfileScreen()), (_) => false),
          ),
        ],
      ),
    );
  }
}

class _ItemButtom extends StatelessWidget {
  final int i;
  final int index;
  final bool isIcon;
  final IconData? icon;
  final String? iconString;
  final Function() onPressed;
  final bool isReel;

  const _ItemButtom({
    Key? key,
    required this.i,
    required this.index,
    required this.onPressed,
    this.icon,
    this.iconString,
    this.isIcon = true,
    this.isReel = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        child: (isIcon)
            ? Icon(icon,
                color: (i == index)
                    ? ColorsCustom.primary
                    : isReel
                        ? Colors.white
                        : Colors.black87,
                size: 28)
            : SvgPicture.asset(iconString!, height: 25),
      ),
    );
  }
}
