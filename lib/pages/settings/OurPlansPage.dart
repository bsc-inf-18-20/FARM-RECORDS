import 'package:flutter/material.dart';

class OurPlansPage extends StatelessWidget {
  const OurPlansPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Define a list of plans for a farm management app
    final List<Plan> plans = [
      Plan(
        title: 'Free Plan',
        description:
            '• Record up to 10 activities per month\n• Basic farm analytics\n• Limited crop tracking',
        actionButtonText: 'Select',
        onPressed: () {
          // Handle Free Plan selection
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Free Plan selected')),
          );
        },
      ),
      Plan(
        title: 'Pro Plan',
        description:
            '• Unlimited activity records\n• Advanced farm analytics\n• Exportable reports\n• Priority support',
        actionButtonText: 'Select',
        onPressed: () {
          // Handle Pro Plan selection
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Pro Plan selected')),
          );
        },
      ),
      Plan(
        title: 'Enterprise Plan',
        description:
            '• Customizable features\n• Multi-farm management\n• API integrations\n• Dedicated support',
        actionButtonText: 'Contact Us',
        onPressed: () {
          // Handle Enterprise Plan contact
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Contact us for Enterprise Plan')),
          );
        },
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Our Plans'),
        backgroundColor:
            const Color.fromARGB(255, 44, 133, 8), // Farm-themed color
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: plans.length,
        itemBuilder: (context, index) {
          final plan = plans[index];
          return PlanTile(plan: plan);
        },
      ),
    );
  }
}

class PlanTile extends StatelessWidget {
  final Plan plan;

  const PlanTile({super.key, required this.plan});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text(
          plan.title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 44, 133, 8),
          ),
        ),
        subtitle: Text(plan.description),
        trailing: ElevatedButton(
          onPressed: plan.onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(
                255, 44, 133, 8), // Green for farming context
          ),
          child: Text(plan.actionButtonText),
        ),
      ),
    );
  }
}

class Plan {
  final String title;
  final String description;
  final String actionButtonText;
  final VoidCallback onPressed;

  Plan({
    required this.title,
    required this.description,
    required this.actionButtonText,
    required this.onPressed,
  });
}
