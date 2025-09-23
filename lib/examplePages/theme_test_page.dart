import 'package:boiler_plater_flutter_v3/core/di/app_binding.dart';
import 'package:flutter/material.dart';
import '../core/constants/colors.dart';
import '../core/constants/sizes.dart';


class ThemeTestPage extends StatefulWidget {
  const ThemeTestPage({super.key});

  @override
  State<ThemeTestPage> createState() => _ThemeTestPageState();
}

class _ThemeTestPageState extends State<ThemeTestPage> {
  @override
  Widget build(BuildContext context) {
    final themeService = AppBinding.themeService;
    return Scaffold(
        appBar: AppBar(
          title: const Text('Theme Testing Page'),
          backgroundColor: ColorConstant.primary,
          foregroundColor: ColorConstant.white,
          actions: [
            ValueListenableBuilder<ThemeMode>(
              valueListenable: themeService,
              builder: (context, themeMode, child) {
                return PopupMenuButton<ThemeMode>(
                  icon: Icon(themeService.themeIcon),
                  tooltip: 'Theme Options',
                  onSelected: (ThemeMode mode) {
                    themeService.setThemeMode(mode);
                  },
                  itemBuilder: (BuildContext context) => [
                    PopupMenuItem<ThemeMode>(
                      value: ThemeMode.light,
                      child: Row(
                        children: [
                          const Icon(Icons.light_mode),
                          const SizedBox(width: Sizes.spaceBtwItems),
                          const Text('Light'),
                          if (themeMode == ThemeMode.light)
                            const Icon(Icons.check, color: ColorConstant.primary),
                        ],
                      ),
                    ),
                    PopupMenuItem<ThemeMode>(
                      value: ThemeMode.dark,
                      child: Row(
                        children: [
                          const Icon(Icons.dark_mode),
                          const SizedBox(width: Sizes.spaceBtwItems),
                          const Text('Dark'),
                          if (themeMode == ThemeMode.dark)
                            const Icon(Icons.check, color: ColorConstant.primary),
                        ],
                      ),
                    ),
                    PopupMenuItem<ThemeMode>(
                      value: ThemeMode.system,
                      child: Row(
                        children: [
                          const Icon(Icons.brightness_auto),
                          const SizedBox(width: Sizes.spaceBtwItems),
                          const Text('System'),
                          if (themeMode == ThemeMode.system)
                            const Icon(Icons.check, color: ColorConstant.primary),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(Sizes.paddingMd),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Theme Toggle Section
              _buildSection(
                title: 'Theme Toggle',
                child: ValueListenableBuilder<ThemeMode>(
                  valueListenable: themeService,
                  builder: (context, themeMode, child) {
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(Sizes.paddingMd),
                        child: Column(
                          children: [
                            Text(
                              'Current Theme: ${themeService.currentThemeString}',
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                            const SizedBox(height: Sizes.spaceBtwItems),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: () => themeService.setThemeMode(ThemeMode.light),
                                    icon: const Icon(Icons.light_mode),
                                    label: const Text('Light'),
                                  ),
                                ),
                                const SizedBox(width: Sizes.spaceBtwItems),
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: () => themeService.setThemeMode(ThemeMode.dark),
                                    icon: const Icon(Icons.dark_mode),
                                    label: const Text('Dark'),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: Sizes.spaceBtwItems),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: () => themeService.setThemeMode(ThemeMode.system),
                                icon: const Icon(Icons.brightness_auto),
                                label: const Text('System'),
                              ),
                            ),
                            const SizedBox(height: Sizes.spaceBtwItems),
                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton.icon(
                                onPressed: () => themeService.toggleTheme(),
                                icon: Icon(themeService.themeIcon),
                                label: const Text('Toggle Theme'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: Sizes.spaceBtwSections),

              // Color Palette Section
              _buildSection(
                title: 'Color Palette',
                child: _buildColorPalette(),
              ),

              const SizedBox(height: Sizes.spaceBtwSections),

              // Typography Section
              _buildSection(
                title: 'Typography',
                child: _buildTypographySection(),
              ),

              const SizedBox(height: Sizes.spaceBtwSections),

              // Buttons Section
              _buildSection(
                title: 'Buttons',
                child: _buildButtonsSection(),
              ),

              const SizedBox(height: Sizes.spaceBtwSections),

              // Form Elements Section
              _buildSection(
                title: 'Form Elements',
                child: _buildFormElementsSection(),
              ),

              const SizedBox(height: Sizes.spaceBtwSections),

              // Cards Section
              _buildSection(
                title: 'Cards',
                child: _buildCardsSection(),
              ),

              const SizedBox(height: Sizes.spaceBtwSections),

              // Chips Section
              _buildSection(
                title: 'Chips',
                child: _buildChipsSection(),
              ),

              const SizedBox(height: Sizes.spaceBtwSections),

              // Icons Section
              _buildSection(
                title: 'Icons & Sizes',
                child: _buildIconsSection(),
              ),
            ],
          ),
        ),
      );
  }

  Widget _buildSection({required String title, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: ColorConstant.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
         const SizedBox(height: Sizes.spaceBtwItems),
        child,
      ],
    );
  }

  Widget _buildColorPalette() {
    final colors = [
      {'name': 'Primary', 'color': ColorConstant.primary},
      {'name': 'Secondary', 'color': ColorConstant.secondary},
      {'name': 'Accent', 'color': ColorConstant.accent},
      {'name': 'Success', 'color': ColorConstant.success},
      {'name': 'Warning', 'color': ColorConstant.warning},
      {'name': 'Error', 'color': ColorConstant.error},
      {'name': 'Info', 'color': ColorConstant.info},
      {'name': 'Black', 'color': ColorConstant.black},
      {'name': 'White', 'color': ColorConstant.white},
      {'name': 'Grey', 'color': ColorConstant.grey},
    ];

    return Wrap(
      spacing: Sizes.spaceBtwItems,
      runSpacing: Sizes.spaceBtwItems,
      children: colors.map((colorData) {
        return Column(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: colorData['color'] as Color,
                borderRadius: BorderRadius.circular(Sizes.borderRadiusMd),
                border: Border.all(color: ColorConstant.borderPrimary),
              ),
            ),
            const SizedBox(height: Sizes.paddingXs),
            Text(
              colorData['name'] as String,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildTypographySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Headline Large', style: Theme.of(context).textTheme.headlineLarge),
        Text('Headline Medium', style: Theme.of(context).textTheme.headlineMedium),
        Text('Headline Small', style: Theme.of(context).textTheme.headlineSmall),
        Text('Title Large', style: Theme.of(context).textTheme.titleLarge),
        Text('Title Medium', style: Theme.of(context).textTheme.titleMedium),
        Text('Title Small', style: Theme.of(context).textTheme.titleSmall),
        Text('Body Large', style: Theme.of(context).textTheme.bodyLarge),
        Text('Body Medium', style: Theme.of(context).textTheme.bodyMedium),
        Text('Body Small', style: Theme.of(context).textTheme.bodySmall),
        Text('Label Large', style: Theme.of(context).textTheme.labelLarge),
        Text('Label Medium', style: Theme.of(context).textTheme.labelMedium),
      ],
    );
  }

  Widget _buildButtonsSection() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {},
                child: const Text('Elevated Button'),
              ),
            ),
            const SizedBox(width: Sizes.spaceBtwItems),
            Expanded(
              child: OutlinedButton(
                onPressed: () {},
                child: const Text('Outlined Button'),
              ),
            ),
          ],
        ),
         const SizedBox(height: Sizes.spaceBtwItems),
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add),
                label: const Text('With Icon'),
              ),
            ),
            const SizedBox(width: Sizes.spaceBtwItems),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.remove),
                label: const Text('With Icon'),
              ),
            ),
          ],
        ),
         const SizedBox(height: Sizes.spaceBtwItems),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {},
            child: const Text('Full Width Button'),
          ),
        ),
      ],
    );
  }

  Widget _buildFormElementsSection() {
    return Column(
      children: [
        TextField(
          decoration: InputDecoration(
            labelText: 'Text Field',
            hintText: 'Enter some text',
            prefixIcon: const Icon(Icons.person),
          ),
        ),
        const SizedBox(height: Sizes.spaceBtwInputFields),
        TextField(
          decoration: InputDecoration(
            labelText: 'Password Field',
            hintText: 'Enter password',
            prefixIcon: const Icon(Icons.lock),
            suffixIcon: const Icon(Icons.visibility),
          ),
          obscureText: true,
        ),
        const SizedBox(height: Sizes.spaceBtwInputFields),
        Row(
          children: [
            Checkbox(
              value: true,
              onChanged: (value) {},
            ),
            const Text('Checked Checkbox'),
          ],
        ),
        Row(
          children: [
            Checkbox(
              value: false,
              onChanged: (value) {},
            ),
            const Text('Unchecked Checkbox'),
          ],
        ),
      ],
    );
  }

  Widget _buildCardsSection() {
    return Column(
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(Sizes.paddingMd),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Card Title',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: Sizes.paddingSm),
                Text(
                  'This is a sample card with some content to demonstrate the card styling.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ),
         const SizedBox(height: Sizes.spaceBtwItems),
        Card(
          elevation: Sizes.cardElevation,
          child: Padding(
            padding: const EdgeInsets.all(Sizes.paddingMd),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: ColorConstant.primary,
                    borderRadius: BorderRadius.circular(Sizes.borderRadiusMd),
                  ),
                  child: const Icon(Icons.image, color: ColorConstant.white),
                ),
                const SizedBox(width: Sizes.spaceBtwItems),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Card with Image',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        'Card subtitle',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildChipsSection() {
    return Wrap(
      spacing: Sizes.spaceBtwItems,
      runSpacing: Sizes.spaceBtwItems,
      children: [
        Chip(label: const Text('Default Chip')),
        Chip(
          label: const Text('Selected Chip'),

        ),
        Chip(
          label: const Text('Deletable Chip'),
          onDeleted: () {},
        ),
        Chip(
          label: const Text('Icon Chip'),
          avatar: const Icon(Icons.star, size: Sizes.iconSm),
        ),
      ],
    );
  }

  Widget _buildIconsSection() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Icon(Icons.home, size: Sizes.iconXs, color: ColorConstant.primary),
            Icon(Icons.favorite, size: Sizes.iconSm, color: ColorConstant.error),
            Icon(Icons.settings, size: Sizes.iconMd, color: ColorConstant.grey),
            Icon(Icons.person, size: Sizes.iconLg, color: ColorConstant.success),
          ],
        ),
         const SizedBox(height: Sizes.spaceBtwItems),
        Text(
          'Icon Sizes: XS (${Sizes.iconXs}), SM (${Sizes.iconSm}), MD (${Sizes.iconMd}), LG (${Sizes.iconLg})',
          style: Theme.of(context).textTheme.bodySmall,
          textAlign: TextAlign.center,
        ),
         const SizedBox(height: Sizes.spaceBtwItems),
        Container(
          width: double.infinity,
          height: 100,
          decoration: BoxDecoration(
            gradient: ColorConstant.primaryGradient,
            borderRadius: BorderRadius.circular(Sizes.borderRadiusMd),
          ),
          child: const Center(
            child: Text(
              'Gradient Background',
              style: TextStyle(
                color: ColorConstant.white,
                fontSize: Sizes.fontSizeLg,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
