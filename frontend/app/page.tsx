import Link from "next/link";

export default function Home() {
  return (
    <main className="p-6">
      <h1 className="text-3xl font-bold">BaseCast Markets</h1>
      <Link href="/create">Create Market</Link>
    </main>
  );
}
