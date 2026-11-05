part of '../main.dart';

class ImageSettingsPage extends StatefulWidget {
  final Game game;
  
  const ImageSettingsPage({super.key, required this.game});
  
  @override
  State<ImageSettingsPage> createState() => _ImageSettingsPageState();
}

class _ImageSettingsPageState extends State<ImageSettingsPage> {
  final ImagePicker _picker = ImagePicker();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bildeinnstillinger'),
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () => Navigator.of(context).pop(),
          child: const Icon(
            CupertinoIcons.back,
            color: AppTheme.primaryColor,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppTheme.spacing),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              IOSCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Bildekategori',
                      style: AppTheme.headlineTextStyle,
                    ),
                    const SizedBox(height: 16),
                    ...ImageCategory.values.map((category) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: IOSButton(
                          text: category.displayName,
                          onPressed: () {
                            setState(() {
                              widget.game.imageCategory = category;
                              ImageManager.setCategory(category);
                            });
                          },
                          isPrimary: widget.game.imageCategory == category,
                          isLarge: true,
                        ),
                      );
                    }),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              if (widget.game.imageCategory == ImageCategory.similarPeople) ...[
                IOSCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Eksempel på kjendispar',
                        style: AppTheme.headlineTextStyle,
                      ),
                      const SizedBox(height: 16),
                      Container(
                        height: 120,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: ImageManager.getCelebrityPairs().length,
                          itemBuilder: (context, index) {
                            final pair = ImageManager.getCelebrityPairs()[index];
                            return Container(
                              width: 140,
                              margin: const EdgeInsets.only(right: 12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          children: [
                                            ClipRRect(
                                              borderRadius: BorderRadius.circular(6),
                                              child: Container(
                                                height: 45,
                                                decoration: BoxDecoration(
                                                  border: Border.all(color: AppTheme.successColor, width: 2),
                                                  borderRadius: BorderRadius.circular(6),
                                                ),
                                                child: Image.network(
                                                  pair.sameImage,
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (context, error, stackTrace) {
                                                    return Container(
                                                      color: AppTheme.backgroundColor,
                                                      child: const Icon(Icons.person, color: AppTheme.textSecondary, size: 16),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              pair.sameName,
                                              style: AppTheme.captionTextStyle.copyWith(
                                                fontSize: 8,
                                                color: AppTheme.successColor,
                                                fontWeight: FontWeight.w600,
                                              ),
                                              textAlign: TextAlign.center,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 3),
                                      Expanded(
                                        child: Column(
                                          children: [
                                            ClipRRect(
                                              borderRadius: BorderRadius.circular(6),
                                              child: Container(
                                                height: 45,
                                                decoration: BoxDecoration(
                                                  border: Border.all(color: AppTheme.destructiveColor, width: 2),
                                                  borderRadius: BorderRadius.circular(6),
                                                ),
                                                child: Image.network(
                                                  pair.oddImage,
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (context, error, stackTrace) {
                                                    return Container(
                                                      color: AppTheme.backgroundColor,
                                                      child: const Icon(Icons.person, color: AppTheme.textSecondary, size: 16),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              pair.oddName,
                                              style: AppTheme.captionTextStyle.copyWith(
                                                fontSize: 8,
                                                color: AppTheme.destructiveColor,
                                                fontWeight: FontWeight.w600,
                                              ),
                                              textAlign: TextAlign.center,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    pair.description,
                                    style: AppTheme.captionTextStyle.copyWith(fontSize: 9),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              border: Border.all(color: AppTheme.successColor, width: 2),
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Text('Gruppebilde', style: AppTheme.captionTextStyle),
                          const SizedBox(width: 16),
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              border: Border.all(color: AppTheme.destructiveColor, width: 2),
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Text('«Odd one out»', style: AppTheme.captionTextStyle),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
              if (widget.game.imageCategory == ImageCategory.custom) ...[
                IOSCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Egne bilder',
                            style: AppTheme.headlineTextStyle,
                          ),
                          CupertinoButton(
                            padding: EdgeInsets.zero,
                            onPressed: _addCustomImage,
                            child: const Icon(
                              CupertinoIcons.add_circled,
                              color: AppTheme.primaryColor,
                              size: 28,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      if (ImageManager.getCustomImages().isEmpty)
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: AppTheme.backgroundColor,
                            borderRadius: BorderRadius.circular(AppTheme.borderRadius),
                            border: Border.all(
                              color: AppTheme.textSecondary.withOpacity(0.3),
                              style: BorderStyle.solid,
                            ),
                          ),
                          child: const Column(
                            children: [
                              Icon(
                                Icons.photo_library_outlined,
                                size: 48,
                                color: AppTheme.textSecondary,
                              ),
                              SizedBox(height: 12),
                              Text(
                                'Ingen bilder lagt til ennå',
                                style: AppTheme.captionTextStyle,
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Trykk på + for å legge til bilder',
                                style: AppTheme.captionTextStyle,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        )
                      else
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                          ),
                          itemCount: ImageManager.getCustomImages().length,
                          itemBuilder: (context, index) {
                            final imagePath = ImageManager.getCustomImages()[index];
                            return Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.file(
                                    File(imagePath),
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: double.infinity,
                                  ),
                                ),
                                Positioned(
                                  top: 4,
                                  right: 4,
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        ImageManager.removeCustomImage(imagePath);
                                      });
                                    },
                                    child: Container(
                                      width: 24,
                                      height: 24,
                                      decoration: const BoxDecoration(
                                        color: AppTheme.destructiveColor,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.close,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
              IOSCard(
                child: Column(
                  children: [
                    const Icon(
                      Icons.info_outline,
                      color: AppTheme.primaryColor,
                      size: 32,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Hvordan det fungerer',
                      style: AppTheme.headlineTextStyle,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.game.imageCategory == ImageCategory.similarPeople
                          ? 'Spillet velger tilfeldig et par med like personer. Alle får samme bilde, unntatt én som får det andre bildet fra paret.'
                          : 'Spillet velger tilfeldig bilder fra den valgte kategorien. Én spiller får et annet bilde enn resten.',
                      style: AppTheme.bodyTextStyle,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Future<void> _addCustomImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );
      
      if (image != null) {
        await ImageManager.addCustomImage(image.path);
        setState(() {});
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Kunne ikke legge til bilde'),
          ),
        );
      }
    }
  }
}
