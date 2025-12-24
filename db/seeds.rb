# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
puts "Cleaning database..."

Proposal.destroy_all
Project.destroy_all
User.destroy_all

puts "Creating users..."

clients = User.create!([
  {
    name: "Client One",
    email_address: "one.client@example.com",
    password: "Password1!",
    role: "client"
  },
  {
    name: "Client Two",
    email_address: "two.client@example.com",
    password: "Password1!",
    role: "client"
  }
])

freelancers = User.create!([
  {
    name: "Freelancer One",
    email_address: "one.freelancer@example.com",
    password: "Password1!",
    role: "freelancer"
  },
  {
    name: "Freelancer Two",
    email_address: "two.freelancer@example.com",
    password: "Password1!",
    role: "freelancer"
  },
  {
    name: "Freelancer Three",
    email_address: "three.freelancer@example.com",
    password: "Password1!",
    role: "freelancer"
  }
])

puts "Creating projects..."

projects = Project.create!([
  {
    title: "Build a Rails web application",
    description: "Looking for a freelancer to build a Rails-based web application with authentication and CRUD features.",
    budget: 2500,
    status: "open",
    client: clients.first
  },
  {
    title: "Design a marketing website",
    description: "Need a responsive marketing site designed using modern UI practices.",
    budget: 1500,
    status: "open",
    client: clients.last
  }
])

puts "Creating proposals..."

Proposal.create!([
  {
    project: projects.first,
    freelancer: freelancers[0],
    message: "I have 3+ years of experience with Ruby on Rails and have built similar applications. I can deliver this project efficiently."
  },
  {
    project: projects.first,
    freelancer: freelancers[1],
    message: "I specialise in full-stack Rails applications and would love to collaborate on this project."
  },
  {
    project: projects.last,
    freelancer: freelancers[2],
    message: "I am a frontend-focused freelancer with strong UI/UX skills and can deliver a clean, modern marketing site."
  }
])

puts "Seed data created successfully!"
puts "Clients: #{User.where(role: 'client').count}"
puts "Freelancers: #{User.where(role: 'freelancer').count}"
puts "Projects: #{Project.count}"
puts "Proposals: #{Proposal.count}"
