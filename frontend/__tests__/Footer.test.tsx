import { render, screen } from '@testing-library/react';
import Footer from '../components/Footer';

describe('Footer', () => {
  it('should render footer text', () => {
    render(<Footer />);
    expect(screen.getByText('© 2024 BaseCast Markets')).toBeInTheDocument();
  });
});
