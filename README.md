# Boat Maintenance Planner AI

A Rails-based web application that helps boat owners track, plan, and optimize vessel maintenance, using AI to predict upcoming needs, suggest tasks, and answer questions about repairs or schedules.

## Features

- **Maintenance Logbook**: Track past and upcoming maintenance tasks by system (engine, hull, electrical, etc.)
- **AI-Powered Maintenance Forecasting**: Get suggestions for maintenance tasks based on your boat's make, model, and usage patterns
- **"Ask the Boat AI" Chat**: Get answers to maintenance questions using a natural language AI interface
- **Visual Dashboard**: View upcoming and overdue tasks at a glance
- **Boat Profile Management**: Store details about your boat for more accurate maintenance recommendations
- **System Component Tracking**: Organize maintenance tasks by boat system

## Technologies Used

- Ruby 3.3.5
- Rails 8.0.2
- PostgreSQL
- Tailwind CSS
- OpenAI API (for AI recommendations and chat)

## Getting Started

### Prerequisites

- Ruby 3.3.5
- PostgreSQL
- Node.js and Yarn (for asset compilation)

### Installation

1. Clone the repository
   ```
   git clone https://github.com/yourusername/boat-agent.git
   cd boat-agent
   ```

2. Install dependencies
   ```
   bundle install
   yarn install
   ```

3. Set up the database
   ```
   rails db:create
   rails db:migrate
   rails db:seed
   ```

4. Add your OpenAI API key to the Rails credentials (for AI features)
   ```
   EDITOR="vim" bin/rails credentials:edit
   ```
   
   Add the following to the credentials file:
   ```yaml
   openai:
     api_key: your_api_key_here
   ```

5. Start the Rails server
   ```
   bin/dev
   ```

6. Visit http://localhost:3000 in your browser

### Demo Account

The seed data includes a demo account:
- Email: demo@example.com
- Password: password

## Development

The application is organized with:

- Models:
  - User: Authentication and user management
  - Boat: Stores boat details
  - MaintenanceTask: Individual maintenance records
  - SystemComponent: Categories for maintenance tasks
  - AIRecommendation: AI-generated maintenance suggestions
  - UserPrompt: Stores chat history with the AI

- Services:
  - OpenaiService: Handles communication with the OpenAI API

## AI Features

### Maintenance Recommendations

The system uses the OpenAI API to generate maintenance recommendations based on:
- Boat type, make, and model
- Engine information
- Current engine hours
- Location (for seasonal recommendations)

### Chat Interface

Users can ask questions about boat maintenance, and the system will provide AI-generated answers. The system includes a mock mode for development without an API key.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- [Ruby on Rails](https://rubyonrails.org/)
- [Tailwind CSS](https://tailwindcss.com/)
- [OpenAI](https://openai.com/) for the AI capabilities
