import React from 'react'

const Input = ({ 
  label, 
  placeholder, 
  value, 
  onChange, 
  type = 'text',
  className = '',
  ...props 
}) => {
  return (
    <div className={`space-y-2 ${className}`}>
      {label && (
        <label className="block text-sm font-medium text-textPrimary dark:text-textPrimary-dark">
          {label}
        </label>
      )}
      <input
        type={type}
        placeholder={placeholder}
        value={value}
        onChange={onChange}
        className="input-field w-full"
        {...props}
      />
    </div>
  )
}

export default Input