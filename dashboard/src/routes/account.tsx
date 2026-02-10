import { createFileRoute, Link } from '@tanstack/react-router'
import { Title, Text, Stack, Anchor } from '@mantine/core'

function AccountComponent() {
  return (
    <Stack gap="md">
      <Anchor component={Link} to="/" size="sm">
        ← Home
      </Anchor>
      <Title order={1}>Account</Title>
      <Text><Text span fw={600}>Email:</Text> user@example.com</Text>
      <Text><Text span fw={600}>Plan:</Text> Free</Text>
      <Text><Text span fw={600}>Since:</Text> January 2025</Text>
    </Stack>
  )
}

export const Route = createFileRoute('/account')({
  component: AccountComponent,
})
