import 'package:flutter/material.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';

class LiquidGlassExample extends StatefulWidget {
  const LiquidGlassExample({Key? key}) : super(key: key);

  @override
  State<LiquidGlassExample> createState() => _LiquidGlassExampleState();
}

class _LiquidGlassExampleState extends State<LiquidGlassExample> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Liquid Glass Examples'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Example 1: Basic Liquid Glass Card
            _buildBasicLiquidGlassCard(),
            const SizedBox(height: 20),
            
            // Example 2: Simple Liquid Glass
            _buildSimpleLiquidGlassCard(),
            const SizedBox(height: 20),
            
            // Example 3: Another Liquid Glass
            _buildAnotherLiquidGlassCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildBasicLiquidGlassCard() {
    return LiquidGlass(
      shape: LiquidRoundedSuperellipse(borderRadius: Radius.circular(20)),
      child: Container(
        height: 200,
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.favorite,
              size: 48,
              color: Colors.white.withOpacity(0.8),
            ),
            const SizedBox(height: 16),
            Text(
              'Basic Liquid Glass',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white.withOpacity(0.9),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Simple glass morphism effect',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSimpleLiquidGlassCard() {
    return LiquidGlass(
      shape: LiquidRoundedSuperellipse(borderRadius: Radius.circular(20)),
      child: Container(
        height: 200,
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.waves,
              size: 48,
              color: Colors.white.withOpacity(0.8),
            ),
            const SizedBox(height: 16),
            Text(
              'Simple Liquid Glass',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white.withOpacity(0.9),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Another example',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnotherLiquidGlassCard() {
    return LiquidGlass(
      shape: LiquidRoundedSuperellipse(borderRadius: Radius.circular(20)),
      child: Container(
        height: 200,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.touch_app,
              size: 48,
              color: Colors.white.withOpacity(0.8),
            ),
            const SizedBox(height: 16),
            Text(
              'Another Liquid Glass',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white.withOpacity(0.9),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'With border decoration',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
