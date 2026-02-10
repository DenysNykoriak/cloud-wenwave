import { createFileRoute } from '@tanstack/react-router'
import { Title, Text } from '@mantine/core'

function IndexComponent() {
  return (
    <>
      <Title order={1}>AWS SaaS</Title>
      <Text mt="sm">Created by Denys Nykoriak using Terraform.</Text>
    </>
  )
}

export const Route = createFileRoute('/')({
  component: IndexComponent,
})
